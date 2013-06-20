class keepalived::install($version) {
  if $version == 'apt-pkg' {
    package { 'keepalived':
      ensure => installed,
    }
  }
  else {
    Class ['keepalived::dependencies'] -> Class['keepalived::install']
    include keepalived::dependencies

    exec { 'download':
      command => "/usr/bin/wget http://www.keepalived.org/software/keepalived-${version}.tar.gz",
      cwd     => '/tmp/',
      creates => "/tmp/keepalived-${version}.tar.gz",
    }

    exec { 'extract':
      command => "/bin/tar -zxvf keepalived-${version}.tar.gz",
      cwd     => '/tmp/',
      creates => "/tmp/keepalived-${version}",
    }

    # TODO: In the event we upgrade versions figure out some way to restart
    Exec['install'] ~> Service['keepalived']

    exec { 'install':
      command => "/tmp/keepalived-${version}/configure && make && sudo make install && sudo touch /etc/keepalived/version_${version}",
      cwd     => "/tmp/keepalived-${version}",
      creates => ['/usr/local/sbin/keepalived', "/etc/keepalived/version_${version}"],
      require => [Exec['extract'], Package['libssl-dev'], Package['libpopt-dev'], Package['build-essential']],
    }

    file { 'executable_permissions':
      path => '/usr/local/sbin/keepalived',
      mode => '0755',
    }

    file { 'config_directory':
      path    => '/etc/keepalived',
      ensure  => directory,
      mode    => '0644',
      recurse => 'true',
    }

    file { 'init_script':
      ensure  => file,
      mode    => '0755',
      path    => '/etc/init.d/keepalived',
      source => "puppet:///modules/keepalived/init.sh",
    }

    exec { 'update-alternatives':
      command => "sudo update-alternatives --install /usr/sbin/keepalived keepalived /usr/local/sbin/keepalived 1",
      require => Exec['install'],
      cwd => '/home',
    }
  }
}
