class dovecot::pop3d (
	$port = 110,
	$ssl_port = 995
) {
	package {'dovecot-pop3d':
		ensure => present
	}

	if defined(Class["iptables"]) {
		iptables::rule { 'allow-pop3-in':
			chain => 'NEWCONNS',
			destination_port => [$port, $ssl_port],
			protocol => 'tcp',
			action => 'ACCEPT',
		}
	}
}
