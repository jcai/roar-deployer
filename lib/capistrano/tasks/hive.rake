require_relative 'shell_helper'
namespace :hive do
  def hadoop_home
    fetch(:hadoop_home)
  end
  def hive_home
    fetch(:hive_home)
  end
  def java_home
    fetch(:java_home)
  end
  def hive_env
    "LD_LIBRARY_PATH=#{hadoop_home}/lib/native JAVA_HOME=#{java_home} HADOOP_HOME=#{hadoop_home}"
  end

  desc "setup hive system"
  task :setup do
    app_path = fetch(:deploy_to)
    dist_dir = "#{app_path}/dist"
    bin_dir = "#{app_path}/bin"
    hive_file=fetch(:hive_file)
    on roles(:hive) do |host|
      execute "mkdir -p #{bin_dir}"
      execute "mkdir -p #{dist_dir}"

      execute "wget #{fetch(:hive_download_url)} 	-O #{dist_dir}/#{hive_file}"
      execute "cd #{dist_dir} && tar xfvz #{hive_file} -C #{bin_dir}"

      sudo '/usr/bin/apt install -yy -qq libsnappy1v5'
    end
  end
  desc "init hive component "
  task :init do
    fs_command = "JAVA_HOME=#{java_home} #{hadoop_home}/bin/hadoop fs "
    on roles(:hive) do |host|
      execute "#{fs_command} -mkdir       -p /tmp"
      execute "#{fs_command} -mkdir       -p /user/hive/warehouse"
      execute "#{fs_command} -chmod g+w   /tmp"
      execute "#{fs_command} -chmod g+w   /user/hive/warehouse"
      execute "#{hive_env} #{hive_home}/bin/schematool -dbType derby -initSchema"
    end
  end
  desc "start hive server"
  task :start do
    on roles(:hive) do |host|
      execute "#{hive_env} #{hive_home}/bin/hiveserver2 "
    end
  end
  desc "stop hive server"
  task :stop do
    on roles(:hive) do |host|
      command = "str=$(#{java_bin}/jcmd|grep HiveServer2|tr ' ' '\\n'|head -n 1) && [ \"$str\" ] && kill -9 $str"
      execute "#{command}",raise_on_non_zero_exit:false
    end
  end
  desc "execute beeline shell on first hive"
  task :beeline do
    hives = roles(:hive)
    if hives.empty?
      raise 'hives is empty'
    end
    host =  hives.first
    puts host
    shell_cmd = "#{hive_env} #{hive_home}/bin/beeline -u jdbc:hive2://#{host}:10000"
    execute_shell(host,shell_cmd)
  end
end
