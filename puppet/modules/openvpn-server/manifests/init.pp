class openvpn-server {

	package { 'openvpn':
		ensure => installed,
		before => File['server.conf'],
	}

	file { 'server.conf':
		ensure => file,
		path => '/etc/openvpn/server.conf',
		require => Package['openvpn'],
		source => "puppet:///modules/openvpn-server/server.conf",
	}

	file { 'sensor.crt':
		ensure => file,
		path => '/etc/openvpn/sensor.crt',
		require => Package['openvpn'],
		source => "puppet:///modules/openvpn-server/sensor.crt",
	}

	file { 'sensor.key':
		ensure => file,
		path => '/etc/openvpn/sensor.key',
		require => Package['openvpn'],
		source => "puppet:///modules/openvpn-server/sensor.key",
	}

	file { 'ca.crt':
		ensure => file,
		path => '/etc/openvpn/ca.crt',
		require => Package['openvpn'],
		source => "puppet:///modules/openvpn-server/ca.crt",
	}

	file { 'dh2014.pem':
		ensure => file,
		path => '/etc/openvpn/dh1024.pem',
		require => Package['openvpn'],
		source => "puppet:///modules/openvpn-server/dh1024.pem",
	}

	#service { 'openvpn':
	#	ensure => 'running',
	#	require => Package['openvpn'],
	#
}
