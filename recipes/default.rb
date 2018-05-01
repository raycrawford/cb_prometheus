#
# Cookbook:: cb_prometheus
# Recipe:: default
#
# Copyright (c) 2018 Ray Crawford, All Rights Reserved.

# If we're hitting the default recipe, assume an exporter is desired

case node['os']
when 'windows'
  Chef::Log.fatal('###=>FATAL: Windows not supported.')
when 'linux'
  Chef::Log.info('###=>INFO: Installing Linux exporter.')
  %w(gcc glibc-static git).each do |package|
    package package do
      action :install
    end
  end
  execute 'Install Go' do
    command "tar -C /usr/local -xzf #{Chef::Config['file_cache_path']}/#{node['usr']['go']['package']}"
    not_if { Dir.exist?("#{node['usr']['go']['home']}") }
  end
  template 'gopath.sh' do
    path '/etc/profile.d/gopath.sh'
    source 'gopath.sh.erb'
    owner 'root'
    group 'root'
    mode '0755'
  end
  template 'node installer' do
    path "#{Chef::Config['file_cache_path']}/installPrometheusNode.sh"
    source 'installPrometheusNode.sh.erb'
    owner 'root'
    group 'root'
    mode '0755'
  end
  execute 'install Prometheus Node Exporter' do
    command "#{Chef::Config['file_cache_path']}/installPrometheusNode.sh"
    not_if { File.exist?("#{node['usr']['go']['home']}/bin/node_exporter") }
  end
  systemd_unit 'node_exporter.service' do
    content(
      'Unit' => {
        'Description' => 'Systemd unit for Prometheus Node Exporter',
        'After' => 'network.target remote-fs.target apiserver.service',
      },
      'Service' => {
        'Type' => 'simple',
        'User' => 'root',
        'ExecStart' => "#{node['usr']['go']['home']}/bin/node_exporter",
        'WorkingDirectory' => '/',
        'Restart' => 'on-failure',
        'RestartSec' => '30s',
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
      },
    )
    notifies :restart, 'service[node_exporter]'
    action :create
  end  
  service 'node_exporter' do
    action [:enable, :start]
  end
else
  Chef::Log.fatal("Node is or Linux.  It is #{node['os']}")
end
