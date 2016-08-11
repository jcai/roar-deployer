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
    hbase_home = fetch(:hbase_home)
    on roles(:hbase) do |host|
      private_config_dir="#{release_path}/config/deploy/#{_stage}/etc/hbase/#{host}"
      public_config_dir="#{release_path}/config/deploy/#{_stage}/etc/hbase/default"

      execute "rm -rf #{hbase_home}/conf/*site.xml"
      if test("[ -d #{private_config_dir} ]")
        execute "ln -s #{private_config_dir}/*  #{hbase_home}/conf/"
      else
        execute "ln -s #{public_config_dir}/*  #{hbase_home}/conf/"
      end
    end
  end
  after 'deploy:publishing','roar:link'
end
