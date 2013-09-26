#puppet-logstash

Puppet manifest to install and configure logstash

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-logstash.png)](http://travis-ci.org/icalvete/puppet-logstash)

See [logstash](http://logstash.net/)

##Actions:

* Install logstash
* Deploy any configuration

##Requires:

* [hiera](http://docs.puppetlabs.com/hiera/1/index.html)

##Examples:

    node 'os02.smartpurposes.net' inherits sp_defaults {

      include roles::puppet_agent
      include roles::syslog_remote_server
      include roles::elasticsearch_server

      class {'roles::logstash_server':
        ls_type        => 'sp',
        ls_type_source => 'sp',
        log_dir        => hiera('sp_log_dir'),
        log            => hiera('sp_log')
      }

      Class['roles::elasticsearch_server']->Class['roles::logstash_server']
    }

Where **$config_dir/modules/sp/modules/sp/templates/logstash_sp.conf.erb** contains ...

    input {
      file {
        type         => '<%= @ls_type %>'
        path         => '<%= @real_log_dir -%>/<%= @log -%>'
      }
    }
    filter {
      grok {
        type         => '<%= @ls_type %>'
        pattern      => ['%{MN}', '%{MNTAI}', '%{MNE}']
        patterns_dir => '/opt/logstash/patterns'
        add_tag      => ['%{app}', '%{sp_enviroment}', '%{status}', '%{action}', '%{tenantapp}', '%{enviroment}']
      }
      mutate {
        type       => '<%= @ls_type %>'
        remove_tag => '_grokparsefailure'
        remove     => ['%{source}', '%{source_host}', '%{source_path}', '%{proccess}']
      }
    }
    output {
      statsd {
        type      => '<%= @ls_type %>'
        tags      => 'success'
        increment => '%{app}.success.%{action}'
      }
      elasticsearch {
        host      => '<%= scope.lookupvar('logstash::params::elasticsearch_vip') %>'
        cluster   => '<%= scope.lookupvar('logstash::params::elasticsearch_cluster_name') %>'
        node_name => 'logstash_<%= @ls_type %>_<%= @hostname %>'
      }
    }

##TODO:

* Documentation

##Authors:
		 
Israel Calvete Talavera <icalvete@gmail.com>
