Puppet::Type.newtype(:dism) do
  @doc = 'Manages Windows features via dism.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The Windows feature name (case-sensitive).'
  end

  newparam(:answer) do
    desc 'The answer file for installing the feature.'
  end

  newparam(:source) do
    desc "The source files needed for installing the feature."
  end
  
  newparam(:limitaccess) do
    desc "Prevent DISM from contacting Windows Update for repair of online images"
    newvalues(:true, :false)
    defaultto(false)
    
    munge do |value|
      resource.munge_boolean(value)
    end
  end
  
  newparam(:all) do
    desc 'A flag indicating if we should install all dependencies or not.'
    newvalues(:true, :false)
    defaultto(false)

    munge do |value|
      resource.munge_boolean(value)
    end
  end

  newparam(:norestart) do
    desc 'Whether to disable restart if the feature specifies it should be restarted'
    newvalues(:true, :false)
    defaultto(true)

    munge do |value|
      resource.munge_boolean(value)
    end
  end

  newparam(:exitcode, :array_matching => :all) do
    desc 'DISM installation process exit code'
    # Ruby truncates exit codes to one bytes (https://bugs.ruby-lang.org/issues/8083)
    # so use truncated codes as workaround.
    #defaultto([0, 3010])
    defaultto([0, 3010, 3010 & 0xFF])
  end

  def munge_boolean(value)
    case value
      when true, "true", :true
        :true
      when false, "false", :false
        :false
      else
        fail("munge_boolean only takes booleans")
    end
  end
end
