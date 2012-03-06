Puppet::Type.type(:dism).provide(:dism) do
  @doc = "Manages Windows features for Windows 2008R2 and Windows 7"

  confine    :operatingsystem => :windows
  defaultfor :operatingsystem => :windows

  commands :dism => 'dism.exe'

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def self.instances
    features = execute ['C:\\Windows\\sysnative\\Dism.exe', '/online', '/Get-Features'].join(' ')
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
      execute['dism.exe', '/online', '/Enable-Feature', "/FeatureName:#{resource[:name]}", "/Apply-Unattend:#{resource[:answer]}"]
    else
      execute ['C:\\Windows\\sysnative\\dism.exe', '/online', '/Enable-Feature', "/FeatureName:#{resource[:name]}"].join(' ')
    end
  end

  def destroy
    execute ['C:\\Windows\\sysnative\\dism.exe', '/online', '/Disable-Feature', "/FeatureName:#{resource[:name]}"].join(' ')
  end

  def currentstate
    feature = execute ['C:\\Windows\\sysnative\\dism.exe', '/online', '/Get-FeatureInfo', "/FeatureName:#{resource[:name]}"].join(' ')
    feature =~ /^State : (\w+)/
    $1
  end

  def exists?
    status = @property_hash[:state] || currentstate
    status == 'Enabled'
  end
end
