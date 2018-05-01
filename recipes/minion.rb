#
# Cookbook:: cb_prometheus
# Recipe:: minion
#
# Copyright (c) 2018 Ray Crawford, All Rights Reserved.


cookbook_file '/root/geoBeater.sh' do
  owner 'root'
  group 'root'
  mode '0755'
end

systemd_unit 'geoBeater.service' do
  content(
    'Unit' => {
      'Description' => 'Beats on the GeoIP service',
      'After' => 'network.target remote-fs.target apiserver.service',
    },
    'Service' => {
      'Type' => 'simple',
      'User' => 'root',
      'ExecStart' => "/root/geoBeater.sh",
      'WorkingDirectory' => '/root',
      'Restart' => 'on-failure',
      'RestartSec' => '30s',
    },
    'Install' => {
      'WantedBy' => 'multi-user.target',
    },
  )
  notifies :restart, 'service[geoBeater]'
  action :create
end  

service 'geoBeater' do
  action [:enable, :start]
end
