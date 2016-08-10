  namespace :hadoop do
    desc "setup hadoop system"
    task :setup do
      _stage = fetch(:stage)
      docker_registry = fetch(:docker_registry)
      app_path = fetch(:deploy_to)
      host_mapping = fetch(:host_mapping)

      binary_dir = "#{app_path}/binary"
      hadoop_file="hadoop-2.5.2.tar.gz"
      hbase_file="hbase-0.98.20-hadoop2-bin.tar.gz"
      jdk_file="server-jre-7u79-linux-x64.tar.gz"
      on roles(:first),in: :sequence do |host|
#	execute "mkdir -p #{binary_dir}"
#	execute "wget http://hadoop.roar/#{hadoop_file} 	-O #{binary_dir}/#{hadoop_file}"
#	execute "wget http://hadoop.roar/#{hbase_file} 		-O #{binary_dir}/#{hbase_file}"
#	execute "wget http://hadoop.roar/#{jdk_file} 		-O #{binary_dir}/#{jdk_file}"
#	execute "cd #{binary_dir} && tar xfvz #{hadoop_file} "
#	execute "cd #{binary_dir} && tar xfvz #{hbase_file} "
#	execute "cd #{binary_dir} && tar xfvz #{jdk_file}"
      end
    end
  end
