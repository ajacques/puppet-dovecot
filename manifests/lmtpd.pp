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

		postfix::config::parameter_list {'postfix_permit_sasl_authenticated':
			variable => 'smtpd_recipient_restrictions',
			order => '005',
			content => 'permit_sasl_authenticated'
		}

		postfix::config::parameter {'postfix_sasl_auth_enable':
			variable => 'smtpd_sasl_auth_enable',
			content => 'yes'
		}

		postfix::config::parameter {'postfix_dovecot_auth':
			variable => 'smtpd_sasl_type',
			content => 'dovecot'
		}

		postfix::config::parameter {'postfix_dovecot_auth_path':
			variable => 'smtpd_sasl_path',
			content => 'private/auth'
		}
	}
}
