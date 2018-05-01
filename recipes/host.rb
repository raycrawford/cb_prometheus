#
# Cookbook:: cb_prometheus
# Recipe:: host
#
# Copyright (c) 2018 Ray Crawford, All Rights Reserved.

docker_service 'default' do
  group 'docker'
  action [:create, :start]
end

docker_image 'fiorix/freegeoip' do
  action :pull
end

docker_container 'freegeoip' do
  repo 'fiorix/freegeoip'
  port ['80:8080', '8888:8888']
  env %w(
    FREEGEOIP_INTERNAL_SERVER=:8888
  )
  restart_policy 'always'
  action :run
end
