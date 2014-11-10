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
    features = dism '/online', '/Get-Features'
    features = features.scan(/^Feature Name : ([\w-]+)\nState : (\w+)/)
    features.collect do |f|
      new(:name => f[0], :state => f[1])
    end
  end

  def flush
    @property_hash.clear
  end

  def create
    if resource[:answer] and resource[:all]
      output = execute([command(:dism), '/online', '/Enable-Feature', '/All', "/FeatureName:#{resource[:name]}", "/Apply-Unattend:#{resource[:answer]}", '/NoRestart'], :failonfail => false)
    elsif resource[:answer]
      output = execute([command(:dism), '/online', '/Enable-Feature', "/FeatureName:#{resource[:name]}", "/Apply-Unattend:#{resource[:answer]}", '/NoRestart'], :failonfail => false)
    elsif resource[:all]
      output = execute([command(:dism), '/online', '/Enable-Feature', '/All', "/FeatureName:#{resource[:name]}", '/NoRestart'], :failonfail => false)
    else
      output = execute([command(:dism), '/online', '/Enable-Feature', "/FeatureName:#{resource[:name]}", '/NoRestart'], :failonfail => false)
    end

    raise Puppet::Error, "Unexpected exitcode: #{$?.exitstatus}\nError:#{output}" unless resource[:exitcode].include? $?.exitstatus

  end

  def destroy
    dism(['/online', '/Disable-Feature', "/FeatureName:#{resource[:name]}"])
  end

  def currentstate
    feature = dism(['/online', '/Get-FeatureInfo', "/FeatureName:#{resource[:name]}"])
    feature =~ /^State : (\w+)/
    $1
  end

  def exists?
    status = @property_hash[:state] || currentstate
    status == 'Enabled'
  end
end
