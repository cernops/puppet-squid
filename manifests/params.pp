class squid::params {

  case $::operatingsystem {
    'RedHat', 'CentOS', 'OracleLinux', 'Scientific': {
      $manage_repo = false
      if $::operatingsystemmajrelease == '5' {
        $managed_repo_package_name = 'squid'
      } else {
        $managed_repo_package_name = ['squid', 'squid-helpers']
      }
    }
    default: {
      $manage_repo = false
      $managed_repo_package_name = 'squid'
    }
  }
  $ensure_service                = 'running'
  $enable_service                = true
  $config                        = '/etc/squid/squid.conf'
  $cache_mem                     = '256 MB'
  $memory_cache_shared           = undef
  $maximum_object_size_in_memory = '512 KB'
  $access_log                    = 'daemon:/var/log/squid/access.log squid'
  $coredump_dir                  = undef
  $max_filedescriptors           = undef
  $workers                       = undef
  $acls                          = undef
  $http_access                   = undef
  $auth_params                   = undef
  $http_ports                    = undef
  $snmp_ports                    = undef
  $cache_dirs                    = undef
  $package_name                  = 'squid'
}
