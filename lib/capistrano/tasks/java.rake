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
  task :gcutil,:process do |t,args|
    process_name = args[:process]
    on roles(:all),in: :sequence do |host|
      command = "str=$(#{java_bin}/jps|grep #{process_name}|tr ' ' '\\n'|head -n 1) && [ \"$str\" ] && #{java_bin}/jstat -gcutil $str"
      execute! command,raise_on_non_zero_exit:false
    end
  end
end
