define keepalived::vrrp_script (
  $script,
  $interval = 2,
  $weight   = false,
  $fall     = false,
  $rise     = false
) {
  concat::fragment { "keepalived.vrrp_script_${name}":
    target  => '/etc/keepalived/keepalived.conf',
    content => template( 'keepalived/vrrp_script.erb' ),
    order   => 20,
    notify  => Service['keepalived'],
    require => Class[ 'keepalived::install' ],
  }
}

