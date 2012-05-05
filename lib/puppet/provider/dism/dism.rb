Puppet::Type.type(:dism).provide(:dism) do
  @doc = "Manages Windows features for Windows 2008R2 and Windows 7"

  confine    :operatingsystem => :windows
  defaultfor :operatingsystem => :windows

  if Puppet.features.microsoft_windows?
    if ENV.has_key?('ProgramFiles(x86)')
      commands :dism => "#{Dir::WINDOWS}\\sysnative\\Dism.exe"
    else
      commands :dism => "#{Dir::WINDOWS}\\system32\\Dism.exe"
    end
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
    if resource[:answer]
      dism '/online', '/Enable-Feature', "/FeatureName:#{resource[:name]}", "/Apply-Unattend:#{resource[:answer]}", '/NoRestart'
    else
      dism '/online', '/Enable-Feature', "/FeatureName:#{resource[:name]}", '/NoRestart'
    end
  end

  def destroy
    dism '/online', '/Disable-Feature', "/FeatureName:#{resource[:name]}"
  end

  def currentstate
    feature = dism '/online', '/Get-FeatureInfo', "/FeatureName:#{resource[:name]}"
    feature =~ /^State : (\w+)/
    $1
  end

  def exists?
    status = @property_hash[:state] || currentstate
    status == 'Enabled'
  end
end
