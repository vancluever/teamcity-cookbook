# teamcity install (server)
include_recipe 'teamcity::_teamcity_common'

# JDBC install
include_recipe 'teamcity::jdbc'

# TC service
TC_MEM_OPTS = "-Xmx#{node['teamcity']['app_mem']}m -XX:MaxPermSize=270m"
TC_CAT_OPTS = " -server -Xmx#{node['teamcity']['app_mem']}m -XX:MaxPermSize=270m" \
              ' -Dteamcity.configuration.path=../conf/teamcity-startup.properties' \
              " -Dlog4j.configuration=file:#{node['teamcity']['app_dir']}/bin/../conf/teamcity-server-log4j.xml" \
              ' -Dteamcity_logs=../logs/ -Djsse.enableSNIExtension=false -Djava.awt.headless=true'

# log directory
directory "#{node['teamcity']['app_dir']}/logs" do
  action :create
  owner node['teamcity']['app_user']
  group node['teamcity']['app_group']
end

poise_service 'teamcity-server' do
  service_name 'teamcity-server'
  command "#{node['teamcity']['app_dir']}/bin/catalina.sh run"
  user node['teamcity']['app_user']
  directory "#{node['teamcity']['app_dir']}/bin"
  environment ({
    HOME: node['teamcity']['app_dir'],
    JAVA_HOME: node['java']['java_home'],
    TEAMCITY_SERVER_MEM_OPTS: TC_MEM_OPTS,
    CATALINA_OPTS: TC_CAT_OPTS,
    CATALINA_HOME: './..',
    CATALINA_BASE: './..',
    TEAMCITY_PID_FILE_PATH: '../logs/teamcity.pid',
    CATALINA_PID: '../logs/teamcity.pid'
  })
end

poise_service_options 'teamcity-server' do
  for_provider :systemd
  template 'poise-systemd.service.erb'
  syslog_identifier 'teamcity-server'
end
