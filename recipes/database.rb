begin
  include_recipe "teamcity::_database_#{node['teamcity']['db_type']}"
rescue Chef::Exceptions::RecipeNotFound
  raise Chef::Exceptions::RecipeNotFound,
        "Database #{node['teamcity']['db_type']} not supported"
end
