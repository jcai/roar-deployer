namespace :git do

  desc "setup git server "
  task :setup do
    git_server_path = fetch(:git_server_path)
    on roles(:git),in: :sequence do |host|
      execute "git init --bare #{git_server_path}"
    end
  end
end
