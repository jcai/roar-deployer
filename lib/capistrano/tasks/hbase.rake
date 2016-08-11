namespace :hbase do
  namespace :zk do
    desc "start zookeeper server"
    task :start do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_zk),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh start zookeeper"
      end
    end
    desc "stop zookeeper server"
    task :stop do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_zk),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh stop zookeeper"
      end
    end
  end
  namespace :master do
    desc "start master server"
    task :start do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_master),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh start master"
      end
    end
    desc "stop master server"
    task :stop do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_master),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh stop master"
      end
    end
  end
  namespace :region do
    desc "start region server"
    task :start do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_region),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh start regionserver"
      end
    end
    desc "stop master server"
    task :stop do
      hbase_home =fetch(:hbase_home)
      java_home=fetch(:java_home)
      on roles(:hbase_region),in: :sequence do |host|
        execute "JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-config.sh  && JAVA_HOME=#{java_home} #{hbase_home}/bin/hbase-daemon.sh stop regionserver"
      end
    end
  end
end
