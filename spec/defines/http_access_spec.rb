require 'spec_helper'

describe 'squid::http_access' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let :pre_condition do
        ' class{"::squid":
            config => "/tmp/squid.conf"
          }
        '
      end
      let(:title) { 'myrule' }
      context 'when parameters are unset' do
        it { should contain_concat_fragment('squid_http_access_myrule').with_target('/tmp/squid.conf') }
        it { should contain_concat_fragment('squid_http_access_myrule').with_order('20-05-allow') }
        it { should contain_concat_fragment('squid_http_access_myrule').with_content(%r{^http_access\s+allow\s+myrule$}) }
      end
      context 'when parameters are set' do
        let(:params) do
          {
            action: 'deny',
            value: 'this and that',
            order: '08'
          }
        end
        it { should contain_concat_fragment('squid_http_access_this and that').with_target('/tmp/squid.conf') }
        it { should contain_concat_fragment('squid_http_access_this and that').with_order('20-08-deny') }
        it { should contain_concat_fragment('squid_http_access_this and that').with_content(%r{^http_access\s+deny\s+this and that$}) }
      end
    end
  end
end
