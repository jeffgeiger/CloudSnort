

class snort {
	package { 'snort':
		ensure => installed,
	}

	service { 'snort':
		require => [ File['snort.conf'], File['snort.debian.conf'] ],
	}

	file { 'pulledpork':
		ensure => directory,
		path => "/etc/pulledpork",
	}

	file { 'snort_dynamicrules':
		ensure => directory,
		path => "/usr/lib/snort_dynamicrules",
	}

	file { 'local.rules':
		ensure => file,
		path => "/etc/snort/rules/local.rules",
		require => Package['snort'],
	}

	package { 'libcrypt-ssleay-perl':
		ensure => installed,
	}

	package { 'liblwp-protocol-https-perl':
		ensure => installed,
	}

	file { 'pulledpork.pl':
		ensure => file,
		path => "/usr/local/bin/pulledpork.pl",
		source => "puppet:///modules/snort/pulledpork.pl",
		mode => 744,
		owner => "root",
		require => [ Package['libcrypt-ssleay-perl'], Package['liblwp-protocol-https-perl'] ],
	}

	file { 'pulledpork.conf':
		ensure => file,
		path => "/etc/pulledpork/pulledpork.conf",
		source => "puppet:///modules/snort/pulledpork.conf",
		require => File['pulledpork'],
	}

	file { 'snort.conf':
		ensure => file,
		path => "/etc/snort/snort.conf",
		source => "puppet:///modules/snort/snort.conf",
		require => Package['snort'],
		notify => Service['snort'],
	}

	file { 'snort.debian.conf':
		ensure => file,
		path => "/etc/snort/snort.debian.conf",
		source => "puppet:///modules/snort/snort.debian.conf",
		require => Package['snort'],
		notify => Service['snort'],
	}	

	exec { 'run_pulledpork':
		command => "/usr/local/bin/pulledpork.pl -c /etc/pulledpork/pulledpork.conf",
		onlyif => '/usr/bin/test "! -f /etc/snort/rules/snort.rules"',
		require => [ File['pulledpork.conf'], Service['snort'] ],
	}

	cron { 'pulledpork_update':
		command => "/usr/local/bin/pulledpork.pl -c /etc/pulledpork/pulledpork.conf",
		user => root,
		hour => 3,
		minute => 15,
		require => File['pulledpork.pl'],
	}
}