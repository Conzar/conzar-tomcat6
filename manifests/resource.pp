# == Defined Type: tomcat6::resource
#
# === Parameters
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
define tomcat6::resource (
	$name,
	$auth,
	$type,
	$driverClassName,
	$url,
	$username,
	$password,
	$maxActive,
	$minIdle,
	$maxIdle,
	$maxWait,
	$minEvictableIdleTimeMillis,
	$timeBetweenEvictionRunsMillis,
	$numTestsPerEvictionRun,
	$poolPreparedStatements,
	$maxOpenPreparedStatements,
	$testOnBorrow,
	$accessToUnderlyingConnectionAllowed,
	$validationQuery
){

}