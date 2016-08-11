namespace :hbase do
  desc "setup hbase system"
  task :setup do
    app_path = fetch(:deploy_to)
    dist_dir = "#{app_path}/dist"
    bin_dir = "#{app_path}/bin"
    hadoop_version = fetch(:hadoop_version)
    hbase_file=fetch(:hbase_file)
    hadoop_home=fetch(:hadoop_home)
    hbase_home=fetch(:hbase_home)
    on roles(:hbase) do |host|
      execute "mkdir -p #{bin_dir}"
      execute "mkdir -p #{dist_dir}"

      execute "wget #{fetch(:hbase_download_url)} 	-O #{dist_dir}/#{hbase_file}"
      execute "cd #{dist_dir} && tar xfvz #{hbase_file} -C #{bin_dir}"

      execute "rm -rf #{hbase_home}/lib/hadoop*.jar"
      execute "cp #{hadoop_home}/share/hadoop/yarn/hadoop-yarn-api-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/yarn/hadoop-yarn-client-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/yarn/hadoop-yarn-common-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/yarn/hadoop-yarn-server-common-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/yarn/hadoop-yarn-server-nodemanager-#{hadoop_version}.jar #{hbase_home}/lib/"

      execute "cp #{hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-client-app-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-client-common-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-client-core-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/mapreduce/hadoop-mapreduce-client-shuffle-#{hadoop_version}.jar #{hbase_home}/lib/"

      execute "cp #{hadoop_home}/share/hadoop/common/hadoop-common-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/common/lib/hadoop-annotations-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/common/lib/hadoop-auth-#{hadoop_version}.jar #{hbase_home}/lib/"
      execute "cp #{hadoop_home}/share/hadoop/hdfs/hadoop-hdfs-#{hadoop_version}.jar #{hbase_home}/lib/"
      hadoop_client_file = "hadoop-client-#{fetch(:hadoop_version)}.jar"
      execute "wget #{fetch(:file_server)}/#{hadoop_client_file} -O #{hbase_home}/lib/#{hadoop_client_file}"
    end
  end
  desc "start all hbase component "
  task :start do
    invoke 'hbase:zk:start'
    invoke 'hbase:master:start'
    invoke 'hbase:region:start'
  end
  desc "stop all hbase component "
  task :stop do
    invoke 'hbase:region:stop'
    invoke 'hbase:master:stop'
    invoke 'hbase:zk:stop'
  end
  namespace :zk do
    desc "start zookeeper server"
    task :start do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_zk),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh start zookeeper"
      end
    end
    desc "stop zookeeper server"
    task :stop do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_zk),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh stop zookeeper"
      end
    end
  end
  namespace :master do
    desc "start master server"
    task :start do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_master),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh start master"
      end
    end
    desc "stop master server"
    task :stop do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_master),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh stop master"
      end
    end
  end
  namespace :region do
    desc "start region server"
    task :start do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_region),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh start regionserver"
      end
    end
    desc "stop master server"
    task :stop do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_region),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh stop regionserver"
      end
    end
  end
end
