# Class: squid::params
#
# This class manages Squid parameters

class squid::params {

  $ensure_service                = 'running'
  $enable_service                = true
  $cache_mem                     = '256 MB'
  $memory_cache_shared           = undef
  $maximum_object_size_in_memory = '512 KB'
  $coredump_dir                  = undef
  $max_filedescriptors           = undef
  $workers                       = undef
  $acls                          = undef
  $http_access                   = undef
  $auth_params                   = undef
  $http_ports                    = undef
  $snmp_ports                    = undef
  $cache_dirs                    = undef

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      case $::operatingsystemrelease {
        /^8.*/: {
          $package_name          = 'squid3'
          $service_name          = 'squid3'
          $config                = '/etc/squid3/squid.conf'
          $group                 = 'root'
          $access_log            = 'daemon:/var/log/squid3/access.log squid'
          $daemon_user           = 'proxy'
          $daemon_group          = 'proxy'
        }
        default: {
          $package_name          = 'squid'
          $service_name          = 'squid'
          $config                = '/etc/squid/squid.conf'
          $group                 = 'squid'
          $access_log            = 'daemon:/var/log/squid/access.log squid'
          $daemon_user           = 'squid'
          $daemon_group          = 'squid'
        }
      }
    }
    default: {
      $package_name              = 'squid'
      $service_name              = 'squid'
      $config                    = '/etc/squid/squid.conf'
      $group                     = 'squid'
      $access_log                = 'daemon:/var/log/squid/access.log squid'
      $daemon_user               = 'squid'
      $daemon_group              = 'squid'
    }
  }
}
