#! /usr/bin/env ruby

require 'spec_helper'
describe Puppet::Type.type(:dism).provider(:dism) do
  #let (:catalog) do Puppet::Resource::Catalog.new end
  let (:type) { Puppet::Type.type(:dism) }
  
  before(:each) do
    # Safety-net stub Should NEVER be called
    Puppet::Util::Execution.expects(:execute).never
    Puppet::Provider.expects(:command).returns('dism.exe')
    
  end
  describe "#create" do

     it "can install with all" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Enable-Feature', '/All', '/FeatureName:NetFx3', '/Quiet', '/NoRestart']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :all => true,
        :provider => described_class.name)
      
      dismtype.provider.create
    end
  
    it "can install all with norestart" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Enable-Feature', '/All', '/FeatureName:NetFx3', '/Quiet', '/NoRestart']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :norestart =>true,
        :all => true,
        :provider => described_class.name)
      
      dismtype.provider.create
    end
    
    it "can install all without norestart" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Enable-Feature', '/All', '/FeatureName:NetFx3', '/Quiet']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :norestart => false,
        :all => true,
        :provider => described_class.name)
      
      dismtype.provider.create
    end

    it "can install with source" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Enable-Feature', '/FeatureName:NetFx3', '/Quiet', '/Source:C:\\myInstall.cab', '/NoRestart']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :source => 'C:\\myInstall.cab',
        :provider => described_class.name)
      
      dismtype.provider.create
    end
    
    it "can install with limitaccess" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Enable-Feature', '/FeatureName:NetFx3', '/Quiet', '/Source:C:\\myInstall.cab',  '/LimitAccess',  '/NoRestart']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :source => 'C:\\myInstall.cab',
        :limitaccess => true,
        :provider => described_class.name)
      
      dismtype.provider.create
    end    
  end
  
  describe "#destroy" do
    it "can install with norestart" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Disable-Feature', '/FeatureName:NetFx3', '/Quiet', '/NoRestart']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :norestart => true,
        :ensure => :absent,
        :provider => described_class.name)
      
      dismtype.provider.destroy
    end

    it "can install without norestart" do      
      Puppet::Type.type(:dism).provider(:dism).expects(:execute_command).with(['dism.exe', '/english', '/online', '/Disable-Feature', '/FeatureName:NetFx3', '/Quiet']).returns(nil)
      
      dismtype = type.new(
        :name => 'NetFx3',
        :norestart => false,
        :ensure => :absent,
        :provider => described_class.name)
      
      dismtype.provider.destroy
    end
  end
  
end
