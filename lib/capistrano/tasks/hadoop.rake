  namespace :hadoop do
    desc "setup hadoop system"
    task :setup do
      _stage = fetch(:stage)
      docker_registry = fetch(:docker_registry)
      app_path = fetch(:deploy_to)
      host_mapping = fetch(:host_mapping)

      dist_dir = "#{app_path}/dist"
      bin_dir = "#{app_path}/bin"
      hadoop_file="hadoop-2.5.2.tar.gz"
      hbase_file="hbase-0.98.20-hadoop2-bin.tar.gz"
      jdk_file="server-jre-7u79-linux-x64.tar.gz"
      on roles(:first),in: :sequence do |host|
	execute "mkdir -p #{bin_dir}"
	execute "mkdir -p #{dist_dir}"
	execute "wget http://hadoop.roar/#{hadoop_file} 	-O #{dist_dir}/#{hadoop_file}"
	execute "wget http://hadoop.roar/#{hbase_file} 		-O #{dist_dir}/#{hbase_file}"
	execute "wget http://hadoop.roar/#{jdk_file} 		-O #{dist_dir}/#{jdk_file}"
	execute "cd #{dist_dir} && tar xfvz #{hadoop_file} -C #{bin_dir}"
	execute "cd #{dist_dir} && tar xfvz #{hbase_file} -C #{bin_dir}"
	execute "cd #{dist_dir} && tar xfvz #{jdk_file} -C #{bin_dir}"
      end
    end
  end
