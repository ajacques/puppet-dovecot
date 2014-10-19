class dovecot::imapd (
	$port = 143,
	$ssl_port = 993
) {
	package {'dovecot-imapd':
		ensure => present
	}

	if defined(Class['iptables']) {
		iptables::rule { 'allow-imap-in':
			chain => 'NEWCONNS',
			destination_port => [$port, $ssl_port],
			protocol => 'tcp',
			action => 'ACCEPT',
		}
	}
}
