namespace :docker do
  namespace :file do
    desc "start file server"
    task :start do
      file_server_port=fetch(:file_server_port)
      file_server_bin=fetch(:file_server_bin)
      file_mirror_bin=fetch(:file_mirror_bin)
      on roles(:file),in: :sequence do |host|
        execute "docker run -d -p #{file_server_port}:80 -v #{file_mirror_bin}:/usr/share/nginx/html/ubuntu -v #{file_server_bin}:/usr/share/nginx/html/software --name file.roar jcai/roar-deployer:file"
      end
    end
    desc "stop file server"
    task :stop do
      file_server_port=fetch(:file_server_port)
      file_server_bin=fetch(:file_server_bin)
      on roles(:file),in: :sequence do |host|
        if test("[ $(docker ps -a|grep file.roar|wc -l) -eq 1 ]")
  	  sudo "docker stop file.roar && docker rm file.roar"
        end
      end
    end
  end
end
