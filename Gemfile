source ENV['GEM_SOURCE'] || "https://rubygems.org"

# Determines what type of gem is requested based on place_or_version.
def gem_type(place_or_version)
  if place_or_version =~ /^git:/
    :git
  elsif place_or_version =~ /^file:/
    :file
  else
    :gem
  end
end

# Find a location or specific version for a gem. place_or_version can be a
# version, which is most often used. It can also be git, which is specified as
# `git://somewhere.git#branch`. You can also use a file source location, which
# is specified as `file://some/location/on/disk`.
def location_for(place_or_version, fake_version = nil)
  if place_or_version =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place_or_version =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place_or_version, { :require => false }]
  end
end


group :development do
  gem 'rake',                                :require => false
  gem 'rspec', '~>3.0',                      :require => false
  gem 'puppet-lint',                         :require => false
  gem 'puppetlabs_spec_helper', '~>0.10.3',  :require => false
  gem 'puppet_facts',                        :require => false
  gem 'mocha', '~>0.10.5',                   :require => false
  gem 'pry',                                 :require => false
end

group :system_tests do
  gem 'beaker-rspec', *location_for(ENV['BEAKER_RSPEC_VERSION'] || '~> 5.1')
  gem 'beaker', *location_for(ENV['BEAKER_VERSION'] || '~> 2.20')
  gem 'beaker-puppet_install_helper',  :require => false
end

# The recommendation is for PROJECT_GEM_VERSION, although there are older ways
# of referencing these. Add them all for compatibility reasons. We'll remove
# later when no issues are known. We'll prefer them in the right order.
puppetversion = ENV['PUPPET_GEM_VERSION'] || ENV['GEM_PUPPET_VERSION'] || ENV['PUPPET_LOCATION'] || '>= 0'
gem 'puppet', *location_for(puppetversion)

# Only explicitly specify Facter/Hiera if a version has been specified.
# Otherwise it can lead to strange bundler behavior. If you are seeing weird
# gem resolution behavior, try setting `DEBUG_RESOLVER` environment variable
# to `1` and then run bundle install.
facterversion = ENV['FACTER_GEM_VERSION'] || ENV['GEM_FACTER_VERSION'] || ENV['FACTER_LOCATION']
gem "facter", *location_for(facterversion) if facterversion
hieraversion = ENV['HIERA_GEM_VERSION'] || ENV['GEM_HIERA_VERSION'] || ENV['HIERA_LOCATION']
gem "hiera", *location_for(hieraversion) if hieraversion


# Evaluate Gemfile.local if it exists
if File.exists? "#{__FILE__}.local"
  eval(File.read("#{__FILE__}.local"), binding)
end

# Evaluate ~/.gemfile if it exists
if File.exists?(File.join(Dir.home, '.gemfile'))
  eval(File.read(File.join(Dir.home, '.gemfile')), binding)
end

# vim:ft=ruby
