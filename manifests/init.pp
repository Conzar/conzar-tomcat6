# == Class: tomcat6
#
# Installs tomcat6 with the defuault settings and ensures that its running
#
# === Parameters
#
# [*resources*] An array of hashes.  Hash values defined here.
#		name,
#		auth,
#		type,
#		driverClassName,
#		url,
#		username,
#		password,
#		maxActive,
#		minIdle,
#		maxIdle,
#		maxWait,
#		minEvictableIdleTimeMillis,
#		timeBetweenEvictionRunsMillis,
#		numTestsPerEvictionRun,
#		poolPreparedStatements,
#		maxOpenPreparedStatements,
#		testOnBorrow,
#		accessToUnderlyingConnectionAllowed,
#		validationQuery
#
# === Variables
#
# [*tomcat_root*] the root directory of tomcat
# [*tomcat_webapps*] the directory to install wars
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
class tomcat6 (
  $resources = '',
){

  $tomcat_root = '/var/lib/tomcat6'
  $tomcat_webapps = "${tomcat_root}/webapps"
  
  ensure_packages(['unzip'])

  package {'tomcat6':
    ensure  => present,
  }
  # make sure that these directories exists
  file {[$tomcat_root,$tomcat_webapps,'/etc/tomcat6']:
    ensure  => directory,
    require => Package['tomcat6'],
  }

  service {'tomcat6':
    ensure    => running,
    require   => Package['tomcat6'],
    subscribe => File['/etc/tomcat6/context.xml'],
  }

  file {'/etc/tomcat6/context.xml':
    ensure  => file,
    content => template('tomcat6/context.xml.erb'),
    require => [Package['tomcat6'],
                File['/etc/tomcat6']
    ]
  }
  # added due to error where tomcat cannot create .java directory
  file {'/usr/share/tomcat6':
    ensure  => directory,
    owner   => 'tomcat6',
    group   => 'tomcat6',
    require => Package['tomcat6']
  }
}