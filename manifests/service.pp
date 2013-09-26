class logstash::service (

  $ls_type = 'default',

) {

  service { "logstash_${ls_type}":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
