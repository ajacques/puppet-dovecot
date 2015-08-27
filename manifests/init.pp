class dovecot (
	$ssl_certificate = undef,
	$ssl_cipher_list = $::ssl_cipher_list,
	$ssl_protocol_list = $::ssl_protocol_list
) {
	group {'dovecot':
		ensure => present
	}

	class {'dovecot::config':
		ssl_certificate => $ssl_certificate,
		ssl_cipher_list => $ssl_cipher_list,
		ssl_protocol_list => $ssl_protocol_list
	}

	exec {'dovecot-reload':
		command => '/usr/bin/env service dovecot reload',
		refreshonly => true
	}

	user {'dovecot':
		comment => 'Dovecot Server Account',
		gid => 'dovecot',
		shell => '/bin/false',
		require => Group['dovecot']
	}	
}
