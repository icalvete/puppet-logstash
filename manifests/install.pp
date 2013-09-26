class logstash::install {

  realize Package['openjdk-7-jre']

  file {'logstash_home':
    ensure  => directory,
    path    => $logstash::params::logstash_home,
    require => Package['openjdk-7-jre']
  }

  file {'logstash_patterns_dir':
    ensure  => directory,
    path    => $logstash::params::logstash_patterns,
    require => Package['openjdk-7-jre']
  }

  common::down_resource {'kibana_get_package':
    scheme   => $logstash::repo_scheme,
    domain   => $logstash::repo_domain,
    port     => $logstash::repo_port,
    user     => $logstash::repo_user,
    pass     => $logstash::repo_pass,
    path     => $logstash::repo_path,
    resource => $logstash::repo_resource,
    target   => $logstash::params::logstash_home,
    require  => File['logstash_home']
  }
}
