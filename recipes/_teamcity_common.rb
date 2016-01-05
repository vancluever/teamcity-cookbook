require 'securerandom'

TC_URL = 'http://download.jetbrains.com/teamcity'
TC_TAR = "TeamCity-#{node['teamcity']['version']}.tar.gz"
TC_TAR_CACHE = "#{Chef::Config[:file_cache_path]}/#{TC_TAR}"
TC_STAGEDIR = "#{Chef::Config[:file_cache_path]}/#{SecureRandom.uuid}"

node.default['java']['jdk_version'] = '7'
include_recipe 'java::default'

group node['teamcity']['app_group'] do
  action :create
end

user node['teamcity']['app_user'] do
  action :create
  manage_home true
  home node['teamcity']['app_dir']
  group node['teamcity']['app_group']
end

# Refactored to only run if the TC homedir is empty of non-hidden files
unless Dir.glob("#{node['teamcity']['app_dir']}/*").length > 0
  remote_file TC_TAR_CACHE do
    action :create
    source "#{TC_URL}/#{TC_TAR}"
  end

  tarball TC_TAR_CACHE do
    action :extract
    destination TC_STAGEDIR
    owner node['teamcity']['app_user']
    group node['teamcity']['app_group']
  end

  if node['teamcity']['agent_files_only']
    execute 'move_tc_files' do
      command "mv #{TC_STAGEDIR}/TeamCity/buildAgent #{node['teamcity']['app_dir']}"
      action :run
    end
    execute 'move_tc_agentplugins' do
      command "mv #{TC_STAGEDIR}/TeamCity/webapps/ROOT/WEB-INF/plugins/*/agent/*.zip #{node['teamcity']['app_dir']}/buildAgent/plugins/"
      action :run
    end
  else
    execute 'move_tc_files' do
      command "mv #{TC_STAGEDIR}/TeamCity/* #{node['teamcity']['app_dir']}"
      action :run
    end
  end
end
