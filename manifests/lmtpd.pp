class dovecot::lmtpd (
	$type = 'unix',
	$socket_path = 'private/dovecot-lmtp'
) {
	package {'dovecot-lmtpd':
		ensure => present
	}

	if defined(Class['postfix']) {
		postfix::config::parameter {'postfix_dovecot_virtual_transport':
			variable => 'virtual_transport',
			content => "lmtp:$type:$socket_path"
		}
	}
}
