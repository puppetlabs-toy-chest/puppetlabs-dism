require 'spec_helper'

provider_class = Puppet::Type.type(:dism).provider(:dism)

RSpec.describe provider_class do
  subject { provider_class }

  shared_examples 'valid enable compile' do
    it {

      @resource = Puppet::Type::Dism.new(params)
      @provider = provider_class.new(@resource)
      Puppet::Provider.stubs(:command).with(:dism).returns('dism.exe')
      File.stubs(:exists?).with('C:\Windows\sysnative\Dism.exe').returns(true)
      cmd = %w(dism.exe /online /Enable-Feature)
      if params[:all] == true
        cmd << '/All'
      end
      cmd << "/FeatureName:#{params[:name]}"
      cmd << '/Quiet'

      if params.has_key?(:source)
        cmd << "/Source:'#{params[:source]}'"
      end
      if params.has_key?(:limitaccess) && params[:limitaccess] == true && params.has_key?(:source)
        cmd << '/LimitAccess'
      end
      if (params.has_key?(:norestart) && params[:norestart] == true) || !(params.has_key?(:norestart))
        cmd << '/NoRestart'
      end


      Puppet::Util::Execution.stubs(:execute).with(
        cmd, {:failonfail => false}
      )
      @provider.create

    }
      end

  shared_examples 'valid disable compile' do
    it {

      @resource = Puppet::Type::Dism.new(params)
      @provider = provider_class.new(@resource)
      Puppet::Util.stubs(:which).with('dism.exe').returns('dism.exe')

      Puppet::Provider.stubs(:command).with(:dism).returns('dism.exe')
      File.stubs(:exists?).with('C:\Windows\sysnative\Dism.exe').returns(true)
      cmd = [
        '/online',
        '/Disable-Feature',
        "/FeatureName:#{params[:name]}",
        '/Quiet'
      ]

      if (params.has_key?(:norestart) && params[:norestart] == true) || !(params.has_key?(:norestart))
        cmd << '/NoRestart'
      end
      subject.expects(:dism).with(cmd)

      @provider.destroy
    }
  end
  describe 'install netfx3' do
    context 'install with all' do
      it_behaves_like 'valid enable compile' do
        let(:params) { {
          :name => 'NetFx3',
          :all => true
        } }
      end
    end
    context 'exercise norestart param' do
      it_behaves_like 'valid enable compile' do
        let(:params) { {
          :name => 'NetFx3',
          :all => true,
          :norestart => false
        } }

      end
      it_behaves_like 'valid enable compile' do
        let(:params) { {
          :name => 'NetFx3',
          :all => true,
          :norestart => true
        } }
      end
    end
    context 'with source' do
      it_behaves_like 'valid enable compile' do
        let(:params) { {
            :name => 'netFx3',
            :source => 'C:\\myInstall.cab'
        } }
      end
    end
    context 'limitaccess' do
      it_behaves_like 'valid enable compile' do
        let(:params) { {
            :name => 'netFx3',
            :source => 'C:\\myInstall.cab',
            :limitaccess => true,
        } }
      end
    end
  end
  describe 'disable netfx3' do
    context 'with all' do
      it_behaves_like 'valid disable compile' do
        let(:params) { {
          :name => 'NetFx3',
          :ensure => :absent
        } }
      end
    end
    context 'exercise norestart param' do
      it_behaves_like 'valid disable compile' do
        let(:params) { {
          :name => 'NetFx3',
          :norestart => false,
          :ensure => :absent
        } }

      end
      it_behaves_like 'valid disable compile' do
        let(:params) { {
          :name => 'NetFx3',
          :norestart => true,
          :ensure => :absent
        } }
      end
    end
  end

end
