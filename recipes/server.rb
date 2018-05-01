#
# Cookbook:: cb_prometheus
# Recipe:: server
#
# Copyright (c) 2018 Ray Crawford, All Rights Reserved.

# Install the server

case node['os']
when 'windows'
when 'linux'

  remote_file 'Prometheus Server binaries' do
    source 'https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.linux-amd64.tar.gz'
    path "#{Chef::Config[:file_cache_path]}/prometheus-2.2.1.linux-amd64.tar.gz"
    not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/prometheus-2.2.1.linux-amd64.tar.gz") }
  end
  execute 'Expand Prometheus Server' do
    command "tar -C #{Chef::Config[:file_cache_path]} -xzf #{Chef::Config[:file_cache_path]}/prometheus-2.2.1.linux-amd64.tar.gz"
    not_if { Dir.exist?('/usr/local/prometheus')}
  end
  execute 'Move Prometheus Server' do
    command "mv #{Chef::Config[:file_cache_path]}/prometheus-2.2.1.linux-amd64 /usr/local/prometheus"
    not_if { Dir.exist?('/usr/local/prometheus')}
  end
  cookbook_file '/usr/local/prometheus/prometheus.yml' do
    owner 'root'
    group 'root'
    mode '0640'
  end
  systemd_unit 'prometheus.service' do
    content(
      'Unit' => {
        'Description' => 'Systemd unit for Prometheus Server',
        'After' => 'network.target remote-fs.target apiserver.service',
      },
      'Service' => {
        'Type' => 'simple',
        'User' => 'root',
        'ExecStart' => "/usr/local/prometheus/prometheus",
        'WorkingDirectory' => '/usr/local/prometheus',
        'Restart' => 'on-failure',
        'RestartSec' => '30s',
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
      },
    )
    notifies :restart, 'service[prometheus]'
    action :create
  end  
  service 'prometheus' do
    action [:enable, :start]
  end
else
    Chef::Log.fatal("Node is not Windows or Linux.  It is #{node['os']}")
end
