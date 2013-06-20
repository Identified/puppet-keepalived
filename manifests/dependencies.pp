class keepalived::dependencies {
  if ! defined(Package['libssl-dev'])      { package { 'libssl-dev':      ensure => installed } }
  if ! defined(Package['libpopt-dev'])     { package { 'libpopt-dev':     ensure => installed } }
  if ! defined(Package['build-essential']) { package { 'build-essential': ensure => installed } }
}
