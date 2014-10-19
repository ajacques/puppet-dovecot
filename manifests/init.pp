class dovecot (
	$ssl_certificate = undef
) {
	group {'dovecot':
		ensure => present
	}

	class {'dovecot::config':
		ssl_certificate => $ssl_certificate
	}

	exec {'dovecot-reload':
		command => '/etc/init.d/dovecot reload',
		refreshonly => true
	}

	user {'dovecot':
		comment => 'Dovecot Server Account',
		gid => 'dovecot',
		shell => '/bin/false',
		require => Group['dovecot']
	}	
}
