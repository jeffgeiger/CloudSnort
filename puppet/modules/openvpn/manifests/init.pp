class openvpn {

	package { 'openvpn':
		ensure => installed,
		before => File['client.conf'],
	}

	file { 'client.conf':
		ensure => file,
		path => '/etc/openvpn/client.conf',
		source => "puppet:///modules/openvpn/client.conf",
		require => Package['openvpn'],
	}

	file { 'cloudclient.crt':
		ensure => file,
		path => '/etc/openvpn/cloudclient.crt',
		source => "puppet:///modules/openvpn/cloudclient.crt",
		require => Package['openvpn'],
	}

	file { 'cloudclient.key':
		ensure => file,
		path => '/etc/openvpn/cloudclient.key',
		source => "puppet:///modules/openvpn/cloudclient.key",
		require => Package['openvpn'],
	}

	file { 'ca.crt':
		ensure => file,
		path => '/etc/openvpn/ca.crt',
		source => "puppet:///modules/openvpn/ca.crt",
		require => Package['openvpn'],
	}
}
