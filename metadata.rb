name 'cb_prometheus'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures cb_prometheus'
long_description 'Installs/Configures cb_prometheus'
version '1.0.0'

source_url 'https://github.com/ray/crawford/cb_prometheus'
issues_url 'https://github.com/raycrawford/cb_prometheus/issues'

chef_version '>= 12.14' if respond_to?(:chef_version)
supports 'windows'
supports 'centos'

depends 'docker', '~> 2.0'
