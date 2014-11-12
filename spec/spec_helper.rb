require 'simplecov'
require 'rspec'
require 'puppetlabs_spec_helper/module_spec_helper'

dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

module PuppetSpec
  FIXTURE_DIR = File.join(dir = File.expand_path(File.dirname(__FILE__)), "fixtures") unless defined?(FIXTURE_DIR)
end

SimpleCov.start do
  add_filter "/spec/"
end
