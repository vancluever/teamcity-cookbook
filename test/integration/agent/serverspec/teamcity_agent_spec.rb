require 'serverspec'

set :backend, :exec

describe 'teamcity home directory contents' do
  it 'only has the buildAgent content' do
    expect(Dir.glob('/opt/teamcity/*')).to eq(['/opt/teamcity/buildAgent'])
  end
end

describe service('teamcity-agent') do
  it { should be_running }
end

describe file('/etc/sudoers.d/teamcity') do
  its(:content) { should match %r{teamcity ALL=\(root\) NOPASSWD:/sbin/reboot} }
end
