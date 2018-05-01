case node['os']
when 'windows'
  default['usr']['go']['package'] = 'go1.10.1.windows-amd64.msi'
  default['usr']['go']['home'] = 'C:\Go'
when 'linux'
  default['usr']['go']['package'] = 'go1.10.1.linux-amd64.tar.gz'
  default['usr']['go']['home'] = '/usr/local/go'
else
  Chef::Log.fatal("Node is not Windows or Linux.  It is #{node['os']}")
end
