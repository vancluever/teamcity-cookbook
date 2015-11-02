# teamcity install (server)
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

  execute 'move_tc_files' do
    command "mv #{TC_STAGEDIR}/TeamCity/* #{node['teamcity']['app_dir']}"
    action :run
  end
end

# log directory
directory "#{node['teamcity']['app_dir']}/logs" do
  action :create
  owner node['teamcity']['app_user']
  group node['teamcity']['app_group']
end

# JDBC install
include_recipe 'teamcity::jdbc'

# TC service
TC_MEM_OPTS = "-Xmx#{node['teamcity']['app_mem']}m -XX:MaxPermSize=270m"
TC_CAT_OPTS = " -server -Xmx#{node['teamcity']['app_mem']}m -XX:MaxPermSize=270m" \
              ' -Dteamcity.configuration.path=../conf/teamcity-startup.properties' \
              " -Dlog4j.configuration=file:#{node['teamcity']['app_dir']}/bin/../conf/teamcity-server-log4j.xml" \
              ' -Dteamcity_logs=../logs/ -Djsse.enableSNIExtension=false -Djava.awt.headless=true'

poise_service 'teamcity-server' do
  service_name 'teamcity'
  command "#{node['teamcity']['app_dir']}/bin/catalina.sh run"
  user node['teamcity']['app_user']
  directory "#{node['teamcity']['app_dir']}/bin"
  environment ({
    JAVA_HOME: node['java']['java_home'],
    TEAMCITY_SERVER_MEM_OPTS: TC_MEM_OPTS,
    CATALINA_OPTS: TC_CAT_OPTS,
    CATALINA_HOME: './..',
    CATALINA_BASE: './..',
    TEAMCITY_PID_FILE_PATH: '../logs/teamcity.pid',
    CATALINA_PID: '../logs/teamcity.pid'
  })
end
