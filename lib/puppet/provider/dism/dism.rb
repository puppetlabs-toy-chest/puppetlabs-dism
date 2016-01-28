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


  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def self.instances
    features = dism '/english', '/online', '/Get-Features'
    features = features.scan(/^Feature Name : ([\w-]+)\nState : (\w+)/)
    features.collect do |f|
      new(:name => f[0], :state => f[1])
    end
  end

  def flush
    @property_hash.clear
  end

  def create
    cmd = [command(:dism), '/english', '/online', '/Enable-Feature']
    if resource[:all]
      cmd << '/All'
    end
    cmd << "/FeatureName:#{resource[:name]}"
    cmd << '/Quiet'
    if resource[:source]
      cmd << "/Source:\"#{resource[:source]}\""
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
    output = execute(cmd, :failonfail => false)
    raise Puppet::Error, "Unexpected exitcode: #{$?.exitstatus}\nError:#{output}" unless resource[:exitcode].include? $?.exitstatus
  end

  def destroy
    cmd = ['/english', '/online', '/Disable-Feature', "/FeatureName:#{resource[:name]}", '/Quiet']
    if resource[:norestart] == :true
      cmd << '/NoRestart'
    end
    dism cmd
  end

  def currentstate
    feature = dism(['/english', '/online', '/Get-FeatureInfo', "/FeatureName:#{resource[:name]}"])
    feature =~ /^State : (\w+)/
    $1
  end

  def exists?
    status = @property_hash[:state] || currentstate
    status == 'Enabled'
  end

end
