class snorby {
	exec { 'apt-get-update':
		command => '/usr/bin/apt-get update',
	}

	$sys_packages = [ "git-core", "default-jre", "imagemagick", "libmagickwand-dev", "wkhtmltopdf", "gcc", "g++", "build-essential", "libssl-dev", "libreadline-gplv2-dev", "zlib1g-dev", "linux-headers-generic", "libsqlite3-dev", "libxslt1-dev", "libxml2-dev", "libmysqlclient-dev", "libmysql++-dev", "ruby1.9.3", "mysql-client" ]

	package { $sys_packages:
		ensure => installed,
		require => Exec['apt-get-update'],
	}
	
	$snorby_gems = [ "thor", "i18n", "tzinfo", "builder", "memcache-client", "rack", "rack-test", "erubis", "mail", "sqlite3", "rack-mount", "rails", "rake", "rubygems-update", "unicorn"] #"text-format", "bundler"

	package { $snorby_gems:
		ensure => installed,
		provider => 'gem',
		require => Package[$sys_packages], 
	}

	file { 'www_dir':
		ensure => 'directory',
		path => '/var/www',
		require => Package[$snorby_gems],
	}

	exec { 'git_snorby':
		command => '/usr/bin/git clone http://github.com/Snorby/snorby.git /var/www/snorby/',
		require => File['www_dir'],
		onlyif => '/usr/bin/test ! -f /var/www/snorby/README.md',
	}

	file { 'database.yml':
		ensure => file,
		path => '/var/www/snorby/config/database.yml',
		source => 'puppet:///modules/snorby/database.yml',
		require => Exec['git_snorby'],
	}

	file { 'snorby_config.yml':
		ensure => file,
		path => '/var/www/snorby/config/snorby_config.yml',
		source => 'puppet:///modules/snorby/snorby_config.yml',
		require => Exec['git_snorby'],
	}

	#Insert unicorn into Gemfile to "unicornize" Snorby
	exec { 'add_unicorn':
		command => '/bin/sed -i "/gem \'rake\', \'0.9.2\'/a gem \'unicorn\', \'4.8.2\'" /var/www/snorby/Gemfile',
		require => Exec['git_snorby'],
		onlyif => '/usr/bin/test ! -f /var/www/snorby/config/snorby-geoip.dat',
	}

	bundler::install { '/var/www/snorby/':
  		#user       => $app_user,
  		#roup      => $app_group,
  		deployment => false,
  		#without    => 'development test doc',
  		require => Exec['add_unicorn'],
	}

	file { 'my.cnf':
		path => "/etc/mysql/my.cnf",
		ensure => file,
		source => 'puppet:///modules/snorby/my.cnf',
		require => Package['mysql-client'],
	}

	exec { 'rake_snorby':
		command => "/usr/local/bin/bundle exec rake snorby:setup",
		cwd => "/var/www/snorby/",
		require => [ Exec['git_snorby'], File['my.cnf'], Bundler::Install['/var/www/snorby/'] ],
		onlyif => '/usr/bin/test ! -f /var/www/snorby/config/snorby-geoip.dat',
	}

  	file { 'unicorn.conf.rb':
  		ensure => file,
  		path => "/var/www/snorby/unicorn.conf.rb",
  		source => "puppet:///modules/snorby/unicorn.conf.rb",
  		require => Exec['rake_snorby'],
  	}

  	file { 'snorby_init':
  		ensure => file,
  		path => "/etc/init.d/snorby",
  		mode => 755,
  		source => "puppet:///modules/snorby/snorby.init",
  		require => Exec['rake_snorby'],
  	}

	#bundler::install { '/var/www/snorby/':
  	#	#user       => $app_user,
  	#	#roup      => $app_group,
  	#	deployment => true,
  	#	without    => 'development test doc',
  	#	require => File['snorby_config.yml'],
	#}
}

