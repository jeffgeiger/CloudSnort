class rc_local::sensor {
	file { 'rc.local':
		path => "/etc/rc.local",
		source => "puppet:///modules/rc_local/rc.local.sensor",
		owner => root,
		group => root,
		mode => 755,
		require => [ Service['snort'], Exec['run_pulledpork'], Package['openvpn'], File['bridge_setup.sh'] ],
	}
}

class rc_local::cloudclient {
	package { 'ethtool':
		ensure => installed,
		before => File['rc.local'],
	}

	file { 'rc.local':
		path => "/etc/rc.local",
		source => "puppet:///modules/rc_local/rc.local.cloudclient",
		owner => root,
		group => root,
		mode => 755,
		require => Package['daemonlogger'],
	}
}