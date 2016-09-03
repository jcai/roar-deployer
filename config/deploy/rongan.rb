server 's1.roar',roles:%w(ubuntu hadoop hbase hadoop_namenode hadoop_datanode hadoop_nodemanager hadoop_resourcemanager hive hbase_region file git)
server 's2.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_master hbase_region)
server 's3.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's4.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)

set :ntp_server,'ntp.roar'
set :file_server_bin,'/opt/software'

set :hbase_region_opts,"-Xmx1G -Xms1G -XX:MaxDirectMemorySize=1G -Dsolr.hdfs.blockcache.slab.count=2 "


#set :hadoop_version,'2.5.2'
#
#set :hbase_version,'0.98.20-hadoop2'
#
#set :hive_version,'2.1.0'
#
#set :java_version,'1.7.0_79'
#set :java_file,'server-jre-7u79-linux-x64.tar.gz'



