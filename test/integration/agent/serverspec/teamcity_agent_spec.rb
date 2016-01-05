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

# NOTE: This test may be prone to a race condition as the ZIP should be
# removed after the plugin is installed on the first-time agent startup.
# However, the test currently seems to run before the ZIP is extracted.
# If this turns out to NOT be the case, then this may change. I want to avoid
# adding a sleep in or something like that for now.
describe file('/opt/teamcity/buildAgent/plugins/idea.zip') do
  it { should exist }
end
