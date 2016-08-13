require_relative 'shell_helper'
namespace :java do
  def java_bin
    "#{fetch(:java_home)}/bin"
  end

  desc "setup hbase system"
  task :bin,:command do |t,args|
    on roles(:all),in: :sequence do |host|
      execute "#{java_bin}/#{args[:command]}"
    end
  end
  task :vmargs,:process do |t,args|
    on roles(:all),in: :sequence do |host|
      execute! "#{java_bin}/jcmd #{args[:process]} VM.flags",raise_on_non_zero_exit:false
    end
  end
end
