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
