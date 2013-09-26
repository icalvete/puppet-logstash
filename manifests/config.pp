class logstash::config (

  $ls_type        = 'default',
  $ls_type_source = 'logstash',
  $log_dir        = undef,
  $log            = undef

) {

  if ! $log_dir {
    fail('log_dir parameter can\'t be empty')
  }

  if ! $log {
    fail('log parameter can\'t be empty')
  }

  $real_log_dir = "${logstash::params::root_log_dir}/${log_dir}"

  file {'logstash_init':
    ensure  => present,
    path    => "/etc/init.d/logstash_${ls_type}",
    content => template("${module_name}/logstash.init.erb"),
    mode    => '0775'
  }

  file {'logstash_conf':
    ensure  => present,
    path    => "${logstash::params::logstash_home}/logstash_${ls_type}.conf",
    content => template("${ls_type_source}/logstash_${ls_type}.conf.erb")
  }

  file {'logstash_patterns':
    ensure  => present,
    path    => "$logstash::params::logstash_patterns/logstash_${ls_type}.patterns",
    content => template("${ls_type_source}/logstash_${ls_type}.patterns.erb")
  }
}
