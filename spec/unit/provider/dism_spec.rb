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
      cmd = ['dism.exe',
             '/online',
             '/Enable-Feature',
             '/All',
             "/FeatureName:#{params[:name]}"
      ]
      if (params.has_key?(:norestart) && params[:norestart] == true) || !params.has_key?(:norestart)
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
          "/FeatureName:#{params[:name]}"
      ]
      if params.has_key?(:norestart) && params[:norestart] == true
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
