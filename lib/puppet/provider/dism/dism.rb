Puppet::Type.type(:dism).provide(:dism) do
  @doc = "Manages Windows features for Windows 2008R2 and Windows 7"

  confine :operatingsystem => :windows
  defaultfor :operatingsystem => :windows
  
  commands :dism =>
             if File.exists? ("#{ENV['SYSTEMROOT']}\\sysnative\\Dism.exe")
               "#{ENV['SYSTEMROOT']}\\sysnative\\Dism.exe"
             elsif  File.exists? ("#{ENV['SYSTEMROOT']}\\system32\\Dism.exe")
               "#{ENV['SYSTEMROOT']}\\system32\\Dism.exe"
             else
               'dism.exe'
             end

  # There does not appear to be a single searchable reference for all error
  # codes DISM could possibly return. This reference for MSIEXEC return codes
  # was the closes thing we could find.
  # https://docs.microsoft.com/en-us/windows/desktop/msi/error-codes
  SUCCESS_EXIT_CODES ||= [0,1641,3010]

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def self.instances
    features = self.execute_command([command(:dism), '/english', '/online', '/Get-Features'])
    features = features.scan(/^Feature Name : ([\w-]+)\nState : (\w+)/)
    features.collect do |f|
      new(:name => f[0], :state => f[1])
    end
  end

  def flush
    @property_hash.clear
  end
  
  def self.execute_command(args)
    output = Puppet::Util::Execution.execute(args, :failonfail => false)
    raise Puppet::Error, "Unexpected exitcode: #{output.exitstatus}\nError:#{output}\nExit Code: #{output.exitstatus}" unless SUCCESS_EXIT_CODES.include?(output.exitstatus)
    output
  end

  def create
    cmd = [command(:dism), '/english', '/online', '/Enable-Feature']

    if resource[:all]
      cmd << '/All'
    end
    cmd << "/FeatureName:#{resource[:name]}"
    cmd << '/Quiet'
    if resource[:source]
      cmd << "/Source:#{resource[:source]}"
    end
    if resource[:answer]
      cmd << "/Apply-Unattend:#{resource[:answer]}"
    end
    if resource[:limitaccess] && resource[:source]
      cmd << '/LimitAccess'
    end
    if resource[:norestart] == :true
      cmd << '/NoRestart'
    end

    resource.provider.class.execute_command(cmd)
  end

  def destroy
    cmd = [command(:dism), '/english', '/online', '/Disable-Feature', "/FeatureName:#{resource[:name]}", '/Quiet']
    if resource[:norestart] == :true
      cmd << '/NoRestart'
    end
    resource.provider.class.execute_command(cmd)
  end

  def currentstate
    feature = resource.provider.class.execute_command([command(:dism), '/english', '/online', '/Get-FeatureInfo', "/FeatureName:#{resource[:name]}"])
    feature =~ /^State : (\w+)/
    $1
  end

  def exists?
    status = @property_hash[:state] || currentstate
    status == 'Enabled'
  end

end
