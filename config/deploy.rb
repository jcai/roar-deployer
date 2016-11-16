# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'roar'
#set :repo_url, 'roar@git.roar:/opt/apps/roar_deployer.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/apps/roar'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5


#config default concurrent
module SSHKit
  class Coordinator
    private
      def default_options
  {in: :groups,limit:10}
      end
  end
end

# set jvm parameter
set :hadoop_namenode_opts,'-Xmx1G -Xms1G'
set :hadoop_datanode_opts,'-Xmx1G -Xms1G'
set :hbase_region_opts,"-Xmx1G -Xms1G -XX:MaxDirectMemorySize=1G -Dsolr.hdfs.blockcache.slab.count=1"

#set file server
set :file_server_port,'80'
set :file_server_bin,'/opt/software'
set :file_server,->{ "http://#{roles(:file)[0]}:#{fetch(:file_server_port)}/software"}
#set git server
set :git_server_path,'/opt/apps/roar_deployer.git'
set :git_server_url,->{ "roar@#{roles(:git)[0]}:#{fetch(:git_server_path)}"}
set :repo_url, -> {fetch(:git_server_url)}


#set file version
set :hadoop_version,'2.7.3'
set :hbase_version,'1.2.4'
set :hive_version,'2.1.0'
set :java_version,'1.7.0_79'
set :java_file,'server-jre-7u79-linux-x64.tar.gz'



# global configuration
set :bin_path,->{"#{fetch(:deploy_to)}/bin"}

set :hadoop_file,->{"hadoop-#{fetch(:hadoop_version)}.tar.gz"}
set :hadoop_download_url,->{"#{fetch(:file_server)}/#{fetch(:hadoop_file)}"}
set :hadoop_home,->{"#{fetch(:bin_path)}/hadoop-#{fetch(:hadoop_version)}"}

set :java_download_url,->{"#{fetch(:file_server)}/#{fetch(:java_file)}"}
set :java_home,->{"/opt/java/jdk#{fetch(:java_version)}"}

set :hbase_file,->{"hbase-#{fetch(:hbase_version)}-bin.tar.gz"}
set :hbase_download_url,->{"#{fetch(:file_server)}/#{fetch(:hbase_file)}"}
set :hbase_home,->{"#{fetch(:bin_path)}/hbase-#{fetch(:hbase_version)}"}

set :hive_file,->{"apache-hive-#{fetch(:hive_version)}-bin.tar.gz"}
set :hive_download_url,->{"#{fetch(:file_server)}/#{fetch(:hive_file)}"}
set :hive_home,->{"#{fetch(:bin_path)}/apache-hive-#{fetch(:hive_version)}-bin"}

set :roar_version,'dev-SNAPSHOT'
set :roar_file,->{"roar-hbase_2.11-#{fetch(:roar_version)}.jar"}
set :roar_download_url,->{"#{fetch(:file_server)}/#{fetch(:roar_file)}"}

#scala-library-2.11.7.jar
set :scala_version,'2.11.7'
set :scala_file,->{"scala-library-#{fetch(:scala_version)}.jar"}
set :scala_download_url,->{"#{fetch(:file_server)}/#{fetch(:scala_file)}"}


ssh_options = {
  keys: %w(keys/id_rsa),
  forward_agent: false,
  auth_methods: %w(publickey password),
}
unless ENV['ROAR_USER'].nil? 
  ssh_options[:user]=ENV['ROAR_USER']
  puts ssh_options
end
set :ssh_options, ssh_options
#use same password for sudo
class SSHKit::Sudo::InteractionHandler
  use_same_password!
end
