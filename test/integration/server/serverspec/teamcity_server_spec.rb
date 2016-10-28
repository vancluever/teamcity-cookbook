require 'serverspec'

set :backend, :exec

describe port('5432') do
  it { should be_listening }
end

describe port('8111') do
  it { should be_listening }
end

describe service('teamcity') do
  it { should be_running }
end

describe service('teamcity') do
  it { should be_running }
end

describe file('/etc/sudoers.d/teamcity') do
  it { should_not exist }
end

describe file('/opt/teamcity/bin/teamcity-server') do
  it { should exist }
  it { should be_symlink }
  it { should be_linked_to '/opt/teamcity/bin/catalina.sh' }
end
