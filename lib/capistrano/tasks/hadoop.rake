namespace :hadoop do
  desc "setup hadoop system"
  task :setup do
    _stage = fetch(:stage)
    docker_registry = fetch(:docker_registry)
    app_path = fetch(:deploy_to)
    host_mapping = fetch(:host_mapping)

    dist_dir = "#{app_path}/dist"
    bin_dir = "#{app_path}/bin"
    hadoop_file=fetch(:hadoop_file)
    jdk_file=fetch(:java_file)
    on roles(:hadoop),in: :sequence do |host|
      execute "mkdir -p #{bin_dir}"
      execute "mkdir -p #{dist_dir}"
      execute "wget #{fetch(:hadoop_download_url)} 	-O #{dist_dir}/#{hadoop_file}"
      execute "wget #{fetch(:java_download_url)} 		-O #{dist_dir}/#{jdk_file}"
      execute "cd #{dist_dir} && tar xfvz #{hadoop_file} -C #{bin_dir}"
      execute "cd #{dist_dir} && tar xfvz #{jdk_file} -C #{bin_dir}"
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
end
