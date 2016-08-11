namespace :roar do
  desc "link roar product files"
  task :link do
    _stage = fetch(:stage)
    app_path = fetch(:deploy_to)
    #deploy cloud
    hadoop_home = fetch(:hadoop_home)
    on roles(:hadoop) do |host|
      private_config_dir="#{release_path}/config/deploy/#{_stage}/etc/hadoop/#{host}"
      public_config_dir="#{release_path}/config/deploy/#{_stage}/etc/hadoop/default"

      execute "rm -rf #{hadoop_home}/etc/hadoop/*site.xml"
      if test("[ -d #{private_config_dir} ]")
        execute "ln -s #{private_config_dir}/*  #{hadoop_home}/etc/hadoop/"
      else
        execute "ln -s #{public_config_dir}/*  #{hadoop_home}/etc/hadoop/"
      end
    end
    on roles(:hbase) do |host|
      private_config_dir="#{release_path}/config/deploy/#{_stage}/etc/hbase/#{host}"
      public_config_dir="#{release_path}/config/deploy/#{_stage}/etc/hbase/default"

      if test("[ -d #{shared_path}/hbase ]")
        execute "unlink #{shared_path}/hbase"
      end
      if test("[ -d #{private_config_dir} ]")
        execute "ln -s #{private_config_dir}  #{shared_path}/hbase"
      else
        execute "ln -s #{public_config_dir}  #{shared_path}/hbase"
      end
    end
  end
  after 'deploy:publishing','roar:link'
end
