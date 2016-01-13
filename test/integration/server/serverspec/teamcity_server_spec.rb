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
