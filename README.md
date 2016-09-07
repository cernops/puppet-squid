Puppet module for Squid
=======================

[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/squid.svg)](https://forge.puppetlabs.com/puppet/squid)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-squid.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-squid)


Description
-----------

Puppet module for configuring the squid caching service.

Usage
-----

The set up a simple squid server with a cache to forward
http port 80 requests.

```puppet
class{'::squid':}
squid::acl{'Safe_ports':
  type    => port,
  entries => ['80'],
}
squid::http_access{'Safe_ports':
  action => allow,
}
squid::http_access{'!Safe_ports':
  action => deny,
}
```

### Parameters for squid Class
Parameters to the squid class almost map 1 to 1 to squid.conf parameters themselves.

* `ensure_service` The ensure value of the squid service, defaults to `running`.
* `enable_service` The enable value of the squid service, defaults to `true`.
* `config` Location of squid.conf file, defaults to `/etc/squid/squid.conf`.
* `config_user` user which owns the config file, defaults to `root`.
* `config_group` group which owns the config file, defaults to `squid`.
* `cache_mem` defaults to `256 MB`. [cache_mem docs](http://www.squid-cache.org/Doc/config/cache_mem/).
* `memory_cache_shared` defaults to undef. [memory_cache_shared docs](http://www.squid-cache.org/Doc/config/memory_cache_shared/).
* `maximum_object_size_in_memory` defaults to `512 KB`. [maximum_object_size_in_memory docs](http://www.squid-cache.org/Doc/config/maximum_object_size_in_memory/)
* `access_log` defaults to `daemon:/var/logs/squid/access.log squid`. [access_log docs](http://www.squid-cache.org/Doc/config/access_log/)
* `coredump_dir` defaults to undef. [coredump_dir docs](http://www.squid-cache.org/Doc/config/coredump_dir/).
* `max_filedescriptors` defaults to undef. [max_filedescriptors docs](http://www.squid-cache.org/Doc/config/max_filedescriptors/).
* `workers` defaults to undef. [workers docs](http://www.squid-cache.org/Doc/config/workers/).
* `acls` defaults to undef. If you pass in a hash of acl entries, they will be defined automatically. [acl entries](http://www.squid-cache.org/Doc/config/acl/).
* `http_access` defaults to undef. If you pass in a hash of http_access entries, they will be defined automatically. [http_access entries](http://www.squid-cache.org/Doc/config/http_access/).
* `http_ports` defaults to undef. If you pass in a hash of http_port entries, they will be defined automatically. [http_port entries](http://www.squid-cache.org/Doc/config/http_port/).
* `service_name` name of the squid service to manage, defaults to `squid`.
* `snmp_ports` defaults to undef. If you pass in a hash of snmp_port entries, they will be defined automatically. [snmp_port entries](http://www.squid-cache.org/Doc/config/snmp_port/).
* `cache_dirs` defaults to undef. If you pass in a hash of cache_dir entries, they will be defined automatically. [cache_dir entries](http://www.squid-cache.org/Doc/config/cache_dir/).

```puppet
class{'::squid':
  cache_mem    => '512 MB',
  workers      => 3,
  coredump_dir => '/var/spool/squid',
}
```

```puppet
class{'::squid':
  cache_mem    => '512 MB',
  workers      => 3,
  coredump_dir => '/var/spool/squid',
  acls         => { 'remote_urls' => {
                       type    => 'url_regex',
                       entries => ['http://example.org/path',
                                   'http://example.com/anotherpath'],
                       },
                  },
  http_access  => { 'our_networks hosts' => { action => 'allow', },
  http_ports   => { '10000' => { options => 'accel vhost'} },
  snmp_ports   => { '1000' => { process_number => 3 },
  cache_dirs   => { '/data/' => { type => 'ufs', options => '15000 32 256 min-size=32769', process_number => 2 }},
}
```

The acls, http_access, http_ports, snmp_port, cache_dirs lines above are equivalent to their examples below.

### Defined Type squid::acl
Defines [acl entries](http://www.squid-cache.org/Doc/config/acl/) for a squid server.

```puppet
squid::acl{'remote_urls':
   type    => 'url_regex',
   entries => ['http://example.org/path',
               'http://example.com/anotherpath'],

}
```

would result in a multi entry squid acl

```
acl remote_urls url_regex http://example.org/path
acl remote_urls url_regex http://example.com/anotherpath
```

These may be defined as a hash passed to ::squid

#### Parameters for  Type squid::acl
* `type` The acltype of the acl, must be defined, e.g url_regex, urlpath_regex, port, ..
* `aclname` The name of acl, defaults to the `title`.
* `entries` An array of acl entries, multiple members results in multiple lines in squid.conf.
* `order` Each ACL has an order `05` by default this can be specified if order of ACL definition matters.


### Defined Type squid::cache\_dir
Defines [cache_dir entries](http://www.squid-cache.org/Doc/config/cache_dir/) for a squid server.

```puppet
squid::cache_dir{'/data':
  type           => 'ufs',
  options        => '15000 32 256 min-size=32769',
  process_number => 2,
}
```

Results in the squid configuration of

```
if ${processor} = 2
cache_dir ufs 15000 32 256 min-size=32769
endif
```

#### Parameters for Type squid::cache\_dir
* `type` the type of cache, e.g ufs. defaults to `ufs`.
* `path` defaults to the namevar, file path to  cache.
* `options` String of options for the cache. Defaults to empty string.
* `process_number` if specfied as an integer the cache will be wrapped
  in a `if $proceess_number` statement so the cache will be used by only
  one process. Default is undef.



### Defined Type squid::http\_access
Defines [http_access entries](http://www.squid-cache.org/Doc/config/http_access/) for a squid server.

```puppet
squid::http_access{'our_networks hosts':
  action => 'allow',
}
```

Adds a squid.conf line 

```
http_access allow our_networks hosts
```

These may be defined as a hash passed to ::squid

#### Parameters for Type squid::http\_allow
* `value` defaults to the `namevar` the rule to allow or deny.
* `action` must be `deny` or `allow`. By default it is allow. The squid.conf file is ordered so by default
   all allows appear before all denys. This can be overidden with the `order` parameter.
* `order` by default is `05`

### Defined Type Squid::Http\_port
Defines [http_port entries](http://www.squid-cache.org/Doc/config/http_port/) for a squid server.

```puppet
squid::http_port{'10000':
  options => 'accel vhost'
}
```

Results in a squid configuration of

```
http_port 10000 accel vhost
```

#### Parameters for Type squid::http\_port
* `port` defaults to the namevar and is the port number.
* `options` A string to specify any options for the default. By default and empty string.

### Defined Type Squid::Snmp\_port
Defines [snmp_port entries](http://www.squid-cache.org/Doc/config/snmp_port/) for a squid server.

```puppet
squid::snmp_port{'1000':
  process_number => 3
}
```

Results in a squid configuration of

```
if ${process_number} = 3
snmp_port 1000
endif
```

#### Parameters for Type squid::http\_port
* `port` defautls to the namevar and is the port number.
* `options` A string to specify any options for the default. By default and empty string.
* `process_number` If set to and integer the snmp\_port is enabled only for
   a particular squid thread. Defaults to undef.

### Defined Type squid::auth\_param
Defines [auth_param entries](http://www.squid-cache.org/Doc/config/auth_param/) for a squid server.

```puppet
squid::auth_param{ 'basic auth_param'
  scheme    => 'basic',
  entries   => ['program /usr/lib64/squid/basic_ncsa_auth /etc/squid/.htpasswd',
                'children 5',
                'realm Squid Basic Authentication',
                'credentialsttl 5 hours'],
}
```

would result in multi entry squid auth_param

```
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/.htpasswd
auth_param basic children 5
auth_param basic realm Squid Basic Authentication
auth_param basic credentialsttl 5 hours
```

These may be defined as a hash passed to ::squid

#### Parameters for  Type squid::auth_param
* `scheme` the scheme used for authentication must be defined
* `entries` An array of entries, multiple members results in multiple lines in squid.conf
* `order` by default is '40'
