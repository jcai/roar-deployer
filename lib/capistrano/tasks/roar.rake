require_relative 'shell_helper'
namespace :roar do
  desc "update roar system"
  task :update do
    roar_file=fetch(:hbase_file)
    hbase_home = fetch(:hbase_home)
    on roles(:hbase) do |host|
      execute "sh -c ' rm -rf #{hbase_home}/lib/roar-hbase*.jar'"
      execute "wget #{fetch(:roar_download_url)} 	-O #{hbase_home}/lib/#{roar_file}"
    end
  end
end
