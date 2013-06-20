define keepalived::vrrp_instance (
  $interface,
  $priority,
  $state,
  $virtual_ips,
  $advert_int        = 1,
  $auth_type         = undef,
  $auth_pass         = undef,
  $nopreempt         = false,
  $notify_all        = false,
  $notify_master     = false,
  $notify_backup     = false,
  $notify_fault      = false,
  $smtp_alert        = false,
  $track_script      = [],
  $virtual_router_id = $name,
) {
  if($state != 'MASTER' and $state != 'BACKUP') {
    fail("${state} is not allowed, only MASTER or BACKUP")
  }

  Keepalived::Vrrp_script[$track_script] -> Keepalived::Vrrp_instance[$name]

  concat::fragment { "keepalived.vrrp_instance_${name}":
    target  => '/etc/keepalived/keepalived.conf',
    content => template( 'keepalived/vrrp_instance.erb' ),
    order   => 50,
    notify  => Service['keepalived'],
    require => Class[ 'keepalived::install' ],
  }
}
