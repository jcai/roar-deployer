namespace :hadoop do
  desc "setup hadoop system"
  task :setup do
    _stage = fetch(:stage)
    app_path = fetch(:deploy_to)

    dist_dir = "#{app_path}/dist"
    bin_dir = "#{app_path}/bin"
    hadoop_file=fetch(:hadoop_file)
    on roles(:hadoop) do |host|
      execute "mkdir -p #{bin_dir}"
      execute "mkdir -p #{dist_dir}"
      execute "wget #{fetch(:hadoop_download_url)} 	-O #{dist_dir}/#{hadoop_file}"
      execute "wget #{fetch(:java_download_url)} 		-O #{dist_dir}/#{jdk_file}"
      execute "cd #{dist_dir} && tar xfvz #{hadoop_file} -C #{bin_dir}"
      execute "cd #{dist_dir} && tar xfvz #{jdk_file} -C #{bin_dir}"
    end
    hadoop_version = fetch(:hadoop_version)
    hbase_file=fetch(:hbase_file)
    hadoop_home=fetch(:hadoop_home)
    hbase_home=fetch(:hbase_home)
    on roles(:hbase) do |host|
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
  namespace :name do
    desc "format name server"
    task :format do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_namenode),in: :sequence do |host|
        execute 'mkdir -p /data/roar/namenode'
        execute 'rm -rf /data/roar/namenode'
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/bin/hdfs namenode -format roar"
      end
    end
    desc "start name server"
    task :start do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_namenode),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/hadoop-daemon.sh --script hdfs start namenode"
      end
    end
    desc "stop name server"
    task :stop  do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_namenode),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/hadoop-daemon.sh --script hdfs stop namenode"
      end
    end
  end
  namespace :data do
    desc "start data server "
    task :start do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_datanode),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/hadoop-daemon.sh --script hdfs start datanode"
      end
    end
    desc "stop data server"
    task :stop  do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_datanode),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/hadoop-daemon.sh --script hdfs stop datanode"
      end
    end
  end
  namespace :yarn do
    desc "start yarn resource manager"
    task :start_manager do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_resourcemanager),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/yarn-daemon.sh start resourcemanager"
      end
    end
    desc "stop yarn resource manager "
    task :stop_manager  do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_resourcemanager),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/yarn-daemon.sh stop resourcemanager"
      end
    end
    desc "start yarn node manager"
    task :start_node do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_nodemanager),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/yarn-daemon.sh start nodemanager"
      end
    end
    desc "stop yarn node manager "
    task :stop_node  do
      hadoop_prefix=fetch(:hadoop_home)
      java_home=fetch(:java_home)
      on roles(:hadoop_nodemanager),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hadoop_prefix}/sbin/yarn-daemon.sh stop nodemanager"
      end
    end
  end
end
