class dovecot::config (
	$ssl_certificate = undef
) {
	$config_root = '/etc/dovecot'
	$pid_path = '/var/run/dovecot/'

	File {
		notify => Exec['dovecot-reload']
	}

	file {$config_root:
		owner => 'dovecot',
		group => 'dovecot',
		mode => '440'
	}

	if $ssl_certificate != undef {
		file {"${config_root}/ssl_certificate.pem":
			owner => 'root',
			group => 'root',
			mode => '400',
			content => $ssl_certificate
		}
	}

	file {$pid_path:
		ensure => directory,
		mode => 0755
	}	
}
