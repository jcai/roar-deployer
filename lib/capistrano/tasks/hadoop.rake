namespace :hadoop do
  desc "setup hadoop system"
  task :setup do
    app_path = fetch(:deploy_to)
    dist_dir = "#{app_path}/dist"
    bin_dir = "#{app_path}/bin"
    hadoop_file=fetch(:hadoop_file)
    on roles(:hadoop) do |host|
      execute "mkdir -p #{bin_dir}"
      execute "mkdir -p #{dist_dir}"
      execute "wget #{fetch(:hadoop_download_url)} 	-O #{dist_dir}/#{hadoop_file}"
      execute "cd #{dist_dir} && tar xfvz #{hadoop_file} -C #{bin_dir}"
    end
  end
  desc "start all hadoop component"
  task:start do
    invoke 'hadoop:name:start'
    invoke 'hadoop:data:start'
  end
  desc "stop all hadoop component"
  task:stop do
    invoke 'hadoop:data:stop'
    invoke 'hadoop:name:stop'
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
