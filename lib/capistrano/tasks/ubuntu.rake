namespace :ubuntu do
  namespace :setup do
    desc "setup roar user"
    task :user do
      on roles(:ubuntu),in: :sequence do |host|
        execute! :sudo, :userdel,'roar',' ; true'
        execute! :sudo,:groupdel,'roar','; true'
        execute! :sudo,'useradd -p $(openssl passwd -1 5iroar) -u 3001 -s /bin/bash -m roar'
      end
    end
    desc "setup ubuntu system"
    task :init do
      _stage = fetch(:stage)
      docker_registry = fetch(:docker_registry)
      on roles(:ubuntu),in: :sequence do |host|
        #setup ssh
        upload! "keys/id_rsa","/tmp/id_rsa"
        upload! "keys/id_rsa.pub","/tmp/id_rsa.pub"
        execute "mkdir -p ~/.ssh"
        execute 'cp /tmp/id_rsa ~/.ssh'
        execute 'cp /tmp/id_rsa.pub ~/.ssh'
        execute "chmod 0600 ~/.ssh/id_rsa"
        execute "cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys"

        #set apt
        upload! "config/deploy/#{_stage}/sources.list","sources.list"
        upload! "config/deploy/#{_stage}/hosts","hosts"

        #init 
        upload! "scripts/init.sh","init.sh"
        upload! "scripts/roar_sudo","roar_sudo"
        #execute! "LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 SUDO_ASKPASS=/bin/echo sudo","MY_HOSTNAME=#{hostname}",:sh,"init.sh"
        execute! "LC_ALL=en_US",'sudo',"MY_HOSTNAME=#{host}",:sh,"init.sh"
        execute "rm init.sh"

      end
    end

    desc "setup ntpdate "
    task :ntp do
      ntp = fetch(:ntp_server)
      ntpdate_cron_file = "/etc/cron.daily/ntpdate"
      on roles(:all),in: :sequence do |host|
        sudo "apt-get -y install ntpdate"
        sudo "sh -c  \"echo 'ntpdate #{ntp}' > #{ntpdate_cron_file} && chmod +x #{ntpdate_cron_file} && ntpdate #{ntp} 2>1& \" "
      end
    end


    task :jdk do 
      _stage = fetch(:stage)
      app_path = fetch(:deploy_to)

      jdk_file=fetch(:java_file)
      java_home=fetch(:java_home)
      bin_dir = "#{java_home}/.."
      on roles(:all),in: :sequence do |host|
        sudo "mkdir -p #{bin_dir}"
        sudo "wget #{fetch(:java_download_url)} -O /tmp/#{jdk_file}"
        sudo "tar xfvz /tmp/#{jdk_file} -C #{bin_dir}"
        sudo "echo 'export PATH=#{java_home}/bin:$PATH' > /tmp/java.sh"
	sudo "chmod +x /tmp/java.sh"
        sudo "mv /tmp/java.sh /etc/profile.d/"
      end
    end
  end
  desc "!!! poweroff !!!"
  task :poweroff do
    on roles(:all) do 
      sudo "poweroff"
    end
  end
end
