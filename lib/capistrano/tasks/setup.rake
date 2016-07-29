  namespace :setup do
    desc "setup ubuntu system"
    task :ubuntu do
      _stage = fetch(:stage)
      docker_registry = fetch(:docker_registry)
      on roles(:all),in: :sequence do |host|
        #setup ssh
        upload! "keys/id_rsa","/tmp/id_rsa"
        upload! "keys/id_rsa.pub","/tmp/id_rsa.pub"
        #execute "mkdir -p ~/.ssh"
        #execute "chmod 0600 ~/.ssh/id_rsa"
        #execute "cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys"

	#set apt
        upload! "config/deploy/#{_stage}/sources.list","sources.list"

	#init 
        upload! "scripts/init.sh","init.sh"
        upload! "scripts/roar_sudo","roar_sudo"
	sudo "DOCKER_REGISTRY=#{docker_registry} sh init.sh"
	execute "rm init.sh"

      end
    end

    desc "setup ntpdate "
    task :ubuntu_ntp do
      ntp = fetch(:ntp_server)
      ntpdate_cron_file = "/etc/cron.daily/ntpdate"
      on roles(:all),in: :sequence do |host|
        sudo "sh -c  \"echo 'ntpdate #{ntp}' > #{ntpdate_cron_file} && chmod +x #{ntpdate_cron_file} && ntpdate #{ntp} \" "
      end
    end

    desc "setup hostname "
    task :hostname do
      on roles(:all),in: :sequence do |host|
        hostname = "gafis" + host.to_s.split(".")[3]
        sudo "sh -c  \"echo '#{hostname}' > /etc/hostname && hostname #{hostname} \" "
      end
    end

    desc "setup memcached "
    task :memcached do
      on roles(:memcached),in: :sequence do |host|
        sudo "apt-get install memcached "
      end
    end

    desc "!!! rm -rf processor data !!!"
    task :rm_processor_data do
      on roles(:processor), in: :sequence, wait: 5 do |host|
        sudo "rm -rf /nirvana/nirvana-processor-*"
      end
    end

    desc "!!! poweroff !!!"
    task :poweroff do
      on roles(:all) do 
        sudo "poweroff"
      end
    end

    task :jdk do 
      file = ENV['JDK_BIN']
      if ! File.exist? file
        puts "#{file} doesn't exists"
      else
        on roles(:all),in: :sequence do |host|
          upload! file,"#{fetch(:tmp_dir)}/#{fetch(:application)}/jdk.tar.gz"
          execute "rm -rf /opt/tools/jdk"
          execute "mkdir -p /opt/tools"
          execute "mkdir -p /opt/nirvana_jdk"
          execute "tar xfvz #{fetch(:tmp_dir)}/#{fetch(:application)}/jdk.tar.gz -C /opt/nirvana_jdk"
          execute "mv /opt/nirvana_jdk/jdk* /opt/tools/jdk"
          execute "echo 'export PATH=/opt/tools/jdk/bin:$PATH' >> /etc/profile"
        end
      end
    end

  end
