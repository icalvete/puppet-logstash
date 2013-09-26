class logstash (

  $ls_type        = undef,
  $ls_type_source = undef,
  $log_dir        = undef,
  $log            = undef,
  $repo_scheme    = $logstash::params::repo_scheme,
  $repo_domain    = $logstash::params::repo_domain,
  $repo_port      = $logstash::params::repo_port,
  $repo_user      = $logstash::params::repo_user,
  $repo_pass      = $logstash::params::repo_pass,
  $repo_path      = $logstash::params::repo_path,
  $repo_resource  = $logstash::params::package

) inherits logstash::params {

  if ! $ls_type {
    fail('ls_type parameter can\'t be empty')
  }

  if ! $ls_type_source {
    fail('ls_type_source parameter can\'t be empty')
  }

  if ! $log_dir {
    fail('log_dir parameter can\'t be empty')
  }

  if ! $log {
    fail('log parameter can\'t be empty')
  }

  anchor{'logstash::begin':
    before  => Class['logstash::install']
  }

  class{'logstash::install':
    require => Anchor['logstash::begin']
  }

  class{'logstash::config':
    ls_type        => $ls_type,
    ls_type_source => $ls_type_source,
    log_dir        => $log_dir,
    log            => $log,
    require        => Class['logstash::install']
  }

  class{'logstash::service':
    ls_type   => $ls_type,
    subscribe => Class['logstash::config']
  }

  anchor{'logstash::end':
    require => Class['logstash::service']
  }
}
