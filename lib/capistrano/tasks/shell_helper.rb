def execute_shell(host,shell_cmd)
  options = host.netssh_options

  cmd = ['ssh', '-t']
  cmd << '-A' if options[:forward_agent]
  Array(options[:keys]).each do |key|
    cmd << '-i'
    cmd << key
  end
  if options[:port]
    cmd << '-p'
    cmd << options[:port]
  end
  user_hostname = [options[:user], host.hostname].compact.join('@')
  cmd << user_hostname


  if host.properties.fetch(:no_release)
    cmd << shell_cmd
  else
    cmd << "cd #{release_path} && #{shell_cmd}"
  end

  puts "Executing #{cmd.join ' '}"
  exec(*cmd)
end
