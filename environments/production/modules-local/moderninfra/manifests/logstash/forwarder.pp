# Class: moderninfra/logstash::forwarder
#
#
class moderninfra::logstash::forwarder {

  apt::source { 'logstashforwarder':
    location    => 'http://packages.elasticsearch.org/logstashforwarder/debian',
    repos       => 'main',
    release     => 'stable',
    include_src => false,
    key         => 'D88E42B4',
    key_server  => 'pgp.mit.edu',
    } -> 

  package { 'logstash-forwarder':
    ensure => installed,
    } ->
  file {
    '/etc/logstash-forwarder':
      ensure  => file,
      owner   => root ,
      group   => root,
      mode    => '0644',
      content => template("${module_name}/logstash-forwarder/basic.conf.erb"),;
  } ~>
  service { "logstash-forwarder":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    # pattern    => 'logstash-forwarder',
  }
}
