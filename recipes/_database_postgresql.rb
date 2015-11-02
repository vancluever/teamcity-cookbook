# Install teamcity database for PostgreSQL

# password login for postgres user should be disabled
unless node['postgresql']['password']['postgres']
  node.default['postgresql']['password']['postgres'] = node['teamcity']['db_password']
end

include_recipe 'apt::default' if node['platform_family'] == 'debian'
include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

# define the TeamCity database
pgsql_connection_info = ({
  host: '127.0.0.1',
  port: 5432,
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
})

postgresql_database_user node['teamcity']['db_username'] do
  action :create
  connection pgsql_connection_info
  password node['teamcity']['db_password']
end

postgresql_database node['teamcity']['db_name'] do
  action :create
  connection pgsql_connection_info
  owner node['teamcity']['db_username']
end
