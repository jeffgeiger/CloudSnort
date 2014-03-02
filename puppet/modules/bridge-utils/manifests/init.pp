class bridge-utils { 
	package { 'bridge-utils':
		ensure => installed,
	}

	file { 'bridge_setup.sh':
		ensure => file,
		owner => "root",
		mode => 744,
		path => "/usr/local/bin/bridge_setup.sh",
		source => "puppet:///modules/bridge-utils/bridge_setup.sh",
		require => Package['bridge-utils'],
	}
}

