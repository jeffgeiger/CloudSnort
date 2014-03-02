

node 'sensor' {
	include openvpn-server
	include bridge-utils
	include snort
	include rc_local::sensor
}

node /^cloudclient\d+$/ {
	include openvpn
	include daemonlogger
	include rc_local::cloudclient
}