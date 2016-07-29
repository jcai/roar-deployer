desc "Report Uptimes"
task :uptime do
  on roles(:all), in: :sequence do |host|
    execute :uptime
    #info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
  end
end
