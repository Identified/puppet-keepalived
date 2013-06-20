class keepalived (
  $notification_email      = undef,
  $notification_email_from = undef,
  $smtp_server             = undef,
  $smtp_connect_timeout    = undef,
  $config_dir              = $keepalived::params::config_dir,
  $ensure                  = installed,
  $version                 = $keepalived::params::version,
  $router_id               = $::hostname,
) inherits keepalived::params {

  Class['keepalived::install'] -> Concat['/etc/keepalived/keepalived.conf'] -> Service['keepalived']

  case $version {
    undef:   { class { 'keepalived::install': version => 'apt-pkg'} }
    default: { class { 'keepalived::install': version => $version } }
  }

  concat { '/etc/keepalived/keepalived.conf':
    warn    => true,
  }

  concat::fragment { 'global_defs':
    target  => '/etc/keepalived/keepalived.conf',
    content => template('keepalived/global_defs.erb'),
    order   => 01,
  }

  service { 'keepalived':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    pattern   => 'keepalived',
  }

}
