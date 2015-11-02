# JDBC bits for teamcity on postgresql

TC_DIRS = {
  data: "#{node['teamcity']['app_dir']}/.BuildServer",
  config: "#{node['teamcity']['app_dir']}/.BuildServer/config",
  lib: "#{node['teamcity']['app_dir']}/.BuildServer/lib",
  jdbc: "#{node['teamcity']['app_dir']}/.BuildServer/lib/jdbc"
}

JDBC_URL_BASE = 'https://jdbc.postgresql.org/download'
JDBC_JAR = 'postgresql-9.4-1204.jdbc41.jar'

TC_DIRS.each_value do |dir|
  directory dir do
    action :create
    owner node['teamcity']['app_user']
    group node['teamcity']['app_group']
  end
end

remote_file "#{TC_DIRS[:jdbc]}/#{JDBC_JAR}" do
  action :create
  source "#{JDBC_URL_BASE}/#{JDBC_JAR}"
  owner node['teamcity']['app_user']
  group node['teamcity']['app_group']
end

file "#{TC_DIRS[:config]}/database.properties" do
  action :create
  owner node['teamcity']['app_user']
  group node['teamcity']['app_group']
  content <<-EOT.gsub(/^ {4}/, '')
    connectionProperties.user=#{node['teamcity']['db_username']}
    connectionProperties.password=#{node['teamcity']['db_password']}
    connectionUrl=jdbc:postgresql://#{['teamcity']['db_host']}/#{['teamcity']['db_name']}
  EOT
end
