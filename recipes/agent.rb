# teamcity install (agent)
node.default['teamcity']['agent_files_only'] = true
include_recipe 'teamcity::_teamcity_common'

# Give the TC user permission to reboot the server
sudo 'teamcity' do
  user node['teamcity']['app_user']
  runas 'root'
  nopasswd true
  commands ['/sbin/reboot']
end

# Agent config file
template "#{node['teamcity']['app_dir']}/buildAgent/conf/buildAgent.properties" do
  source 'buildAgent.properties.erb'
  action :create
end

# Agent service
poise_service 'teamcity-agent' do
  service_name 'teamcity-agent'
  command "#{node['teamcity']['app_dir']}/buildAgent/bin/agent.sh run"
  user node['teamcity']['app_user']
  directory "#{node['teamcity']['app_dir']}"
  environment ({
    HOME: node['teamcity']['app_dir'],
    JAVA_HOME: node['java']['java_home'],
    LC_CTYPE: node['teamcity']['agent_locale']
  })
end
