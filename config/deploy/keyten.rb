server 's1.roar',roles:%w(ubuntu hadoop hbase hadoop_namenode hadoop_datanode hadoop_nodemanager hadoop_resourcemanager hbase_master hive hbase_region file git)
server 's2.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's3.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's4.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_zk hbase_region)
server 's5.roar',roles:%w(ubuntu hadoop hbase hadoop_nodemanager )
#server 's6.roar',roles:%w(ubuntu hadoop hbase hbase_region)
server 's7.roar',roles:%w(ubuntu hadoop hbase hadoop_datanode hadoop_nodemanager hbase_region)




set :ntp_server,'s1.roar'
set :file_server_bin,'/opt/software'

set :hbase_region_opts,"-Xmx5G -Xms5G -XX:MaxDirectMemorySize=4G -Dsolr.hdfs.blockcache.slab.count=15 "


#set :hadoop_version,'2.5.2'
#
#set :hbase_version,'0.98.20-hadoop2'
#
#set :hive_version,'2.1.0'
#
#set :java_version,'1.7.0_79'
#set :java_file,'server-jre-7u79-linux-x64.tar.gz'



