# Class: profile::rmq
#
#
class profiles::rmq (
$hostname=undef)
{
  class { '::rabbitmq':
    ssl                      => true,
    ssl_verify               => 'verify_peer',
    ssl_fail_if_no_peer_cert => true,
    ssl_cacert               => '/etc/puppet/ssl/certs/ca.pem',
    ssl_cert                 => "/var/lib/puppet/ssl/certs/$hostname.pem",
    ssl_key                  => "/var/lib/puppet/ssl/private_keys/$hostname.pem",
    stomp_port               => 61613,
    config_stomp             => true,
  } ->
  rabbitmq_vhost { '/sensu':
    ensure => present,
  }
  rabbitmq_user_permissions { 'guest@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
  rabbitmq_user { 'sensu':
    admin    => true,
    password => 'meep',
  }
  rabbitmq_user_permissions { 'sensu@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  puppet_certificate { "$hostname":
    ensure => present,
  }

}