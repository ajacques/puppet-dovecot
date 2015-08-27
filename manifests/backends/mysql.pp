class dovecot::backends::mysql (
	$username = undef,
	$password = undef,
	$database = undef,
	$hostname = undef,
) {
	$connect_string = "host=${hostname} dbname=${database} user=${username} password=${password}"

	package {'dovecot-mysql':
		ensure => installed
	}

	file {'/etc/dovecot/dovecot-sql.conf.ext':
		owner => 'root',
		group => 'dovecot',
		mode => '0440',
		content => template('dovecot/sql-mysql.conf.erb')
	}

	if defined(Class['postfix']) {
		postfix::sql_map {'sql-virtual_mailbox_domains':
			username => $username,
			password => $password,
			hosts => $hostname,
			dbname => $database,
			query => "SELECT DISTINCT 1 FROM email_aliases WHERE SUBSTRING_INDEX(email_address, '@', -1) = '%s';"
		}

		postfix::sql_map {'sql-virtual_mailbox_maps':
			username => $username,
			password => $password,
			hosts => $hostname,
			dbname => $database,
			query => "SELECT DISTINCT 1 FROM email_aliases WHERE email_address = '%s' OR (SUBSTRING_INDEX(email_address, '@', -1) = SUBSTRING_INDEX('%s', '@', -1) AND SUBSTRING(email_address, 1, 1) = '@');"
		}

		postfix::config::parameter {'dovecot_mailbox_domains':
			variable => 'virtual_mailbox_domains',
			content => 'mysql:/etc/postfix/sql-virtual_mailbox_domains.cf'
		}

		postfix::config::parameter {'dovecot_mailbox_maps':
			variable => 'virtual_mailbox_maps',
			content => 'mysql:/etc/postfix/sql-virtual_mailbox_maps.cf'
		}
	}
}
