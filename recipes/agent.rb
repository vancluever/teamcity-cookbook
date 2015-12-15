# teamcity install (agent)
node.default['teamcity']['agent_files_only'] = true
include_recipe 'teamcity::_teamcity_common'

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
  environment JAVA_HOME: node['java']['java_home']
end
