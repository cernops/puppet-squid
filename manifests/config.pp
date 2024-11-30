# @summary
#   Configure the system to use squid
#   config is included in the main class `squid`
#   for parameters see `squid` class
# @api private
class squid::config (
  $config                        = $squid::config,
  $config_user                   = $squid::config_user,
  $config_group                  = $squid::config_group,
  $cache_mem                     = $squid::cache_mem,
  $cache_replacement_policy      = $squid::cache_replacement_policy,
  $memory_replacement_policy     = $squid::memory_replacement_policy,
  $visible_hostname              = $squid::visible_hostname,
  $via                           = $squid::via,
  $httpd_suppress_version_string = $squid::httpd_suppress_version_string,
  $forwarded_for                 = $squid::forwarded_for,
  $memory_cache_shared           = $squid::memory_cache_shared,
  $maximum_object_size_in_memory = $squid::maximum_object_size_in_memory,
  $access_log                    = $squid::access_log,
  $buffered_logs                 = $squid::buffered_logs,
  $coredump_dir                  = $squid::coredump_dir,
  $max_filedescriptors           = $squid::max_filedescriptors,
  $error_directory               = $squid::error_directory,
  $err_page_stylesheet           = $squid::err_page_stylesheet,
  $workers                       = $squid::workers,
  $acls                          = $squid::acls,
  $http_access                   = $squid::http_access,
  $send_hit                      = $squid::send_hit,
  $snmp_access                   = $squid::snmp_access,
  $icp_access                    = $squid::icp_access,
  $auth_params                   = $squid::auth_params,
  $http_ports                    = $squid::http_ports,
  $https_ports                   = $squid::https_ports,
  $url_rewrite_program           = $squid::url_rewrite_program,
  $url_rewrite_children          = $squid::url_rewrite_children,
  $url_rewrite_child_options     = $squid::url_rewrite_child_options,
  $refresh_patterns              = $squid::refresh_patterns,
  $snmp_incoming_address         = $squid::snmp_incoming_address,
  $snmp_ports                    = $squid::snmp_ports,
  $ssl_bump                      = $squid::ssl_bump,
  $sslproxy_cert_error           = $squid::sslproxy_cert_error,
  $cache_dirs                    = $squid::cache_dirs,
  $cache                         = $squid::cache,
  $extra_config_sections         = $squid::extra_config_sections,
  $squid_bin_path                = $squid::squid_bin_path,
) inherits squid {
  concat { $config:
    ensure       => present,
    owner        => $config_user,
    group        => $config_group,
    mode         => '0640',
    validate_cmd => "${squid_bin_path} -k parse -f %",
  }

  concat::fragment { 'squid_header':
    target  => $config,
    content => template('squid/squid.conf.header.erb'),
    order   => '01',
  }

  if $acls {
    create_resources('squid::acl', $acls)
  }
  if $access_log {
    if $access_log =~ Hash {
      # Use create_resources if $access_log is a hash
      create_resources('squid::access_log', $access_log)
    } elsif $access_log =~ Array {
      # Use a loop to iterate over the $access_log array if it's an array
      $access_log.each |$log| {
        squid::access_log { $log['module']:
          entries => $log['entries'],
        }
      }
    } elsif $access_log =~ String {
      # Use regsubst to extract the module and the remaining entries
      $module = regsubst($access_log, '^(\w+):(.*)$', '\1')
      $entries = regsubst($access_log, '^(\w+):(.*)$', '\2')  
      # Create a single access_log resource using the extracted module and entries
      squid::access_log { $module:
        module  => $module,
        entries => $entries,
      }
    }
  }
  if $http_access {
    create_resources('squid::http_access', $http_access)
  }
  if $send_hit {
    create_resources('squid::send_hit', $send_hit)
  }
  if $snmp_access {
    create_resources('squid::snmp_access', $snmp_access)
  }
  if $icp_access {
    create_resources('squid::icp_access', $icp_access)
  }
  if $auth_params {
    create_resources('squid::auth_param', $auth_params)
  }
  if $http_ports {
    create_resources('squid::http_port', $http_ports)
  }
  if $https_ports {
    create_resources('squid::https_port', $https_ports)
  }
  if $snmp_ports {
    create_resources('squid::snmp_port', $snmp_ports)
  }
  if $cache_dirs {
    create_resources('squid::cache_dir', $cache_dirs)
  }
  if $cache {
    create_resources('squid::cache', $cache)
  }
  if $refresh_patterns {
    create_resources('squid::refresh_pattern', $refresh_patterns)
  }
  if $ssl_bump {
    create_resources('squid::ssl_bump', $ssl_bump)
  }
  if $sslproxy_cert_error {
    create_resources('squid::sslproxy_cert_error', $sslproxy_cert_error)
  }
  create_resources('squid::extra_config_section', $extra_config_sections)
}
