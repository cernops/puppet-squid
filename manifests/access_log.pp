# @summary
#   Defines access_log entries for a squid server.
# @see
#   http://www.squid-cache.org/Doc/config/access_log/
# @example
#   squid::access_log: { 'myAccessLog' :
#      module    => 'syslog'
#      entries => [
#        'place daemon'
#        'logformat squid'
#        'acl hasRequest'
#     ],
# }
#
#   Adds a squid.conf line:
#   squid::access_log: syslog:daemon squid hasRequest
# @param module
#   Location of access log
# @param entries
#   Access log entry's preceding comment
# @param order
#   Order can be used to configure where in `squid.conf`this configuration section should occur.
define squid::access_log (
  Enum['none', 'stdio', 'daemon', 'syslog', 'udp', 'tcp'] $module,
  Variant[String, Array[String]] $entries,
  String $access_log_name = $title,
  String $order           = '50',
) {
  $entries_array = $entries ? {
    String  => [$entries],
    default => $entries,
  }

  $entries_array.each |$entry| {
    concat::fragment { "squid_access_log_${access_log_name}_${entry}":
      target  => $squid::config,
      content => epp('squid/squid.conf.access_log.epp', { 'module' => $module, 'entry' => $entry }),
      order   => "38-${order}-${module}",
    }
  }
}
