Puppet::Type.type(:dism).provide(:dism) do
  @doc = "Manages Windows features for Windows 2008R2 and Windows 7"

  confine    :operatingsystem => :windows
  defaultfor :operatingsystem => :windows

  commands :dims => 'dism.exe'

  def self.instances
    features = execute['dism.exe', '/online', '/Get_Features'].scan(/^Feature Name : ([\w-]+)\nState : (\w+)/)
    features.collect do |f|
      new(:name => f[0])
    end
  end

  def create
    if resource[:answer]
      execute['dism.exe', '/online/', '/Enable-Feature', "/FeatureName:#{resource[:name]}", "/Apply-Unattend:#{resource[:answer]}"]
    else
      execute['dism.exe', '/online/', '/Enable-Feature', "/FeatureName:#{resource[:name]}"]
    end
  end

  def destroy
    execute['dism.exe', '/online/', '/Disable-Feature', "/FeatureName:#{resource[:name]}"]
  end

  def exists?
    execute['dism.exe', '/online', '/Get-FeatureInfo', "/FeatureName:#{resource[:name]}"].scan(/^State : (\w+)/) == 'Enabled'
  end
end
