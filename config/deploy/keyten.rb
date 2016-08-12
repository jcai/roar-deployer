# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}

# concat ip
def ip_range (ips)
  return ips.map{|x| '192.168.1.'+x.to_s()}.to_a()
end
class SSHKit::Sudo::InteractionHandler
  use_same_password!
#  password_prompt_regexp /[Pp]assword.*:/
#  password_prompt_regexp /.*密码：/
end

#only no setup os
#set :host_mapping,{
#	'192.168.1.100'=>'s1.roar',
#	'192.168.1.101'=>'s2.roar',
#	'192.168.1.102'=>'s3.roar',
#	'192.168.1.103'=>'s4.roar',
#	'192.168.1.104'=>'s5.roar',
##	'192.168.1.105'=>'s6.roar',
#	'192.168.1.106'=>'s7.roar',
#	}
#
#role :first ,ip_range(Array(100..104).concat(Array(106)))

server 's1.roar',roles:%w(ubuntu hadoop hbase hadoop_namenode hadoop_datanode hadoop_nodemanager hadoop_resourcemanager hbase_master)
server 's2.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's3.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's4.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's5.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_region)
server 's7.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_region)

set :ntp_server,'s1.roar'



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.


set :file_server,'http://hadoop.roar'
set :hadoop_version,'2.5.2'
set :java_version,'1.7.0_79'
set :java_file,'server-jre-7u79-linux-x64.tar.gz'

set :hbase_version,'0.98.20-hadoop2'


# not custom
set :bin_path,->{"#{fetch(:deploy_to)}/bin"}

set :hadoop_file,->{"hadoop-#{fetch(:hadoop_version)}.tar.gz"}
set :hadoop_download_url,->{"#{fetch(:file_server)}/#{fetch(:hadoop_file)}"}
set :hadoop_home,->{"#{fetch(:bin_path)}/hadoop-#{fetch(:hadoop_version)}"}

set :java_download_url,->{"#{fetch(:file_server)}/#{fetch(:java_file)}"}
set :java_home,->{"/opt/java/jdk#{fetch(:java_version)}"}

set :hbase_file,->{"hbase-#{fetch(:hbase_version)}-bin.tar.gz"}
set :hbase_download_url,->{"#{fetch(:file_server)}/#{fetch(:hbase_file)}"}
set :hbase_home,->{"#{fetch(:bin_path)}/hbase-#{fetch(:hbase_version)}"}






# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
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
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
