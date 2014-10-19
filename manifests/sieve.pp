class dovecot::sieve (
) {
	package {'dovecot-sieve':
		ensure => $ensure
	}
}
