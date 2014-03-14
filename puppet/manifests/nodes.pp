
node 'database' {
	exec { 'apt-update':
		command => '/usr/bin/apt-get update',
	}

	class { 'mysql::server':
  		root_password    => 'strongpassword',
  		#bind-address = 127.0.0.1
  		override_options => { 'mysqld' => { 'bind-address' => '0.0.0.0' } },
  		users => {
  			'root@%' => {
		    	ensure                   => 'present',
    			max_connections_per_hour => '0',
    			max_queries_per_hour     => '0',
    			max_updates_per_hour     => '0',
    			max_user_connections     => '0',
    			password_hash            => '*FAB0955B2CE7AE2DAFEE46C36501AFC5E65D445D',
  			},
  		},
 		grants => {
		 'root@%' => {
 			   ensure     => 'present',
    			options    => ['GRANT'],
    			privileges => ['ALL'],
    			table      => '*.*',
    			user       => 'root@%',
  			},
		},
  		require => Exec['apt-update'],
  	}

}

node 'sensor' {
	include openvpn-server
	include bridge-utils
	include snort
	include rc_local::sensor
	include snorby
}

node /^cloudclient\d+$/ {
	include openvpn
	include daemonlogger
	include rc_local::cloudclient
}