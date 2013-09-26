class logstash::params {

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {

      $repo_scheme                = hiera('sp_repo_scheme')
      $repo_domain                = hiera('sp_repo_domain')
      $repo_port                  = hiera('sp_repo_port')
      $repo_user                  = hiera('sp_repo_user')
      $repo_pass                  = hiera('sp_repo_pass')
      $repo_path                  = hiera('sp_repo_path')
      $package                    = hiera('logstash_package')

      $logstash_home              = '/opt/logstash'
      $logstash_patterns          = "${logstash_home}/patterns"
      $root_log_dir               = hiera('root_log_dir')

      $elasticsearch_cluster_name = hiera('elasticsearch_cluster_name')
      $elasticsearch_vip          = hiera('elasticsearch_vip')

    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }
}
