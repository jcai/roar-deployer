# roar-deployer


简述
=========
本项目主要是一键部署大数据软件，支持ubuntu 16.04 LTS 操作系统，实现集群化对操作系统进行设置、软件安装、远程命令支持。


安装步骤
=========
1. 前期准备

  * 新建集群配置，假设集群名称为me,在config/deploy下建立自己集群文件me.rb以及文件夹me，示例见：config/deploy/keyten
  * 配置NTP服务器,如果有NTP服务器则可忽略此步
  * 配置集群机器的hosts文件，config/deploy/me/hosts;示例见: config/deploy/keyten/hosts
  * 更改本机的/etc/hosts文件,以方便操作远程服务器
  * 配置ubuntu机器使用的镜像源设置文件,config/deploy/me/sources.list;示例见: config/deploy/keyten/sources.list
  * 配置当前集群，修改config/deploy/me.rb;示例见: config/deploy/keyten.rb 
  * 设置NGINX文件服务器，供下载软件使用,软件目录包含如下:

    hadoop-2.5.2.tar.gz hadoop-client-2.5.2.jar hbase-0.98.20-hadoop2-bin.tar.gz server-jre-7u79-linux-x64.tar.gz
  * 安装docker.

    ```sh
      sudo apt-get install docker.io
      sudo usermod -aG docker $(whoami)
    ```

    退出当前用户，重新登录系统.
    如果无互联网环境，需要导入roar-deployer的docker文件:

      ```sh
        docker load < roar-deployer.tgz
      ```


2. 启动文件服务器

  ```sh
    docker run -d -p 80:80 -v /opt/software:/usr/share/nginx/html/software --name file.roar jcai/roar-deployer:file
  ```

3. 运行管理系统
  
  ```sh
    bin/manager
  ```
  

4. 设置操作系统，(用户支持sudo权限,假设用户名为ubuntu)
  ```sh
  ROAR_USER=ubuntu cap me ubuntu:setup:user ubuntu:setup:hosts ubuntu:setup:init ubuntu:setup:ntp ubuntu:setup:jdk
  ```
   操作完之后,通常需要重启服务器,下面命令中的s2.roar为你要重启的机器
    ```sh
    ROAR_USER=ubuntu cap me -z s2.roar ubuntu:reboot
    ```

4. 配置GIT服务器，把当前配置内容push到git服务器中
   初始化git服务器
  ```sh
  cap me git:setup
  ```
  添加内容比较提交到远程服务器
  ```sh
  git add .
  git commit -a -m 'add my configruation files'
  git remote add me roar@git.roar
  git push me master
  ```

6. 部署hadoop
  ```sh
  cap me hadoop:setup
  ```
  
7. 部署hbase
  ```sh
  cap me hbase:setup
  ```
8. 部署配置
  ```sh
  cap me deploy
  ```
  
9. 操作hadoop集群
 
 * 启动hadoop集群
   
   ```sh
   cap me hadoop:start
   ```
 * 启动yarn
   
   ```sh
   cap me hadoop:start_yarn
   ```
 * 停止yarn
   
   ```sh
   cap me hadoop:stop_yarn
   ```
 * 停止hadoop
   
   ```sh
   cap me hadoop:stop
   ```
 * 访问hdfs集群
   
   ```sh
   cap me hadoop:fs[-ls /]
   ```
10. 操作hbase集群
  
 * 启动hbase集群
  
   ```sh
   cap me hbase:start
   ```
 * 停止hbase集群
  
   ```sh
   cap me hbase:stop
   ```
 * 打开hbase的shell
   
   ```sh
   cap me hbase:shell
   ```
11. 常用命令
  
  ```sh
  cap deploy                         # Deploy a new release
  cap git:setup                      # setup git server
  cap hadoop:data:start              # start data server
  cap hadoop:data:stop               # stop data server
  cap hadoop:fs[fs_cmd]              # exexcute fs shell
  cap hadoop:name:format             # format name server
  cap hadoop:name:start              # start name server
  cap hadoop:name:stop               # stop name server
  cap hadoop:setup                   # setup hadoop system
  cap hadoop:start                   # start all hadoop component
  cap hadoop:start_yarn              # start yarn cluster
  cap hadoop:stop                    # stop all hadoop component
  cap hadoop:stop_yarn               # stop yarn cluster
  cap hadoop:yarn:start_manager      # start yarn resource manager
  cap hadoop:yarn:start_node         # start yarn node manager
  cap hadoop:yarn:stop_manager       # stop yarn resource manager
  cap hadoop:yarn:stop_node          # stop yarn node manager
  cap hbase:master:start             # start master server
  cap hbase:master:stop              # stop master server
  cap hbase:region:start             # start region server
  cap hbase:region:stop              # stop region server
  cap hbase:setup                    # setup hbase system
  cap hbase:shell                    # execute hbase shell on first master server
  cap hbase:start                    # start all hbase component
  cap hbase:stop                     # stop all hbase component
  cap hbase:zk:start                 # start zookeeper server
  cap hbase:zk:stop                  # stop zookeeper server
  cap hive:beeline                   # execute beeline shell on first hive
  cap hive:init                      # init hive component
  cap hive:setup                     # setup hive system
  cap hive:start                     # start hive server
  cap hive:stop                      # stop hive server
  cap install                        # Install Capistrano, cap install STAGES=staging,production
  cap java:bin[command]              # execute command under java/bin directory
  cap java:gcutil[process]           # view gcutil of java process
  cap java:vmargs[process]           # view vmargs of java process
  cap roar:install_scala             # install scala library
  cap roar:link                      # link roar product files
  cap roar:update                    # update roar system
  cap ubuntu:poweroff                #
  cap ubuntu:reboot                  #
  cap ubuntu:setup:hosts             # update hosts
  cap ubuntu:setup:init              # setup ubuntu system
  cap ubuntu:setup:jdk               # install jdk
  cap ubuntu:setup:ntp               # setup ntpdate
  cap ubuntu:setup:user              # setup roar user
  cap uptime                         # Report Uptimes
  ```


