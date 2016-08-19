require_relative 'shell_helper'
namespace :roar do
  desc "update roar system"
  task :update do
    roar_file=fetch(:roar_file)
    hbase_home = fetch(:hbase_home)
    on roles(:hbase) do |host|
      execute "sh -c ' rm -rf #{hbase_home}/lib/roar-hbase*.jar'"
      execute "wget #{fetch(:roar_download_url)} 	-O #{hbase_home}/lib/#{roar_file}"
    end
  end
  desc 'install scala library'
  task :install_scala do
    scala_file=fetch(:scala_file)
    hbase_home = fetch(:hbase_home)
    on roles(:hbase) do |host|
      execute "sh -c ' rm -rf #{hbase_home}/lib/scala-library*.jar'"
      execute "wget #{fetch(:scala_download_url)} 	-O #{hbase_home}/lib/#{scala_file}"
    end
  end
end
