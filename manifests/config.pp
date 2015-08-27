class dovecot::config (
	$ssl_certificate = undef,
	$ssl_cipher_list = undef,
	$ssl_protocol_list = undef
) {
	$config_root = '/etc/dovecot'
	$pid_path = '/var/run/dovecot/'

	File {
		notify => Exec['dovecot-reload']
	}

	file {$config_root:
		owner => 'root',
		group => 'root',
		mode => '0755'
	}

	if $ssl_certificate != undef {
		$ssl_certificate_path = "${config_root}/ssl_certificate.pem"
		file {$ssl_certificate_path:
			owner => 'root',
			group => 'root',
			mode => '400',
			source => $ssl_certificate
		}

		file {"${config_root}/conf.d/10-ssl.conf":
			content => template('dovecot/ssl.conf.erb')
		}
	}

	file {$pid_path:
		ensure => directory,
		mode => 0755
	}	
}
