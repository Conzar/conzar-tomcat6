# Tomcat6 puppet module

Author: Michael Speth <spethm@landcareresearch.co.nz>

## About

This module installs, configures, and manages Apache Tomcat6.

## Installation

The module can be obtained from the [Puppet Forge](http://forge.puppetlabs.com/conzar/tomcat6).  The easiest method for installation is to use the
[puppet-module tool](https://github.com/puppetlabs/puppet-module-tool).  Run the following command from your modulepath:

`puppet-module install conzar/tomcat6`

## Requirements
Note, the puppet packages below should automatically be installed if the puppet module command is used.

 * Ubuntu Operating System.
 * Puppetlabs/apache module.  Can be obtained here: http://forge.puppetlabs.com/puppetlabs/apache or with the command `puppet module install puppetlabs/apache`
 * Puppetlabs/postgresqldb module.  Can be obtained here: http://forge.puppetlabs.com/puppetlabs/postgresqldb or with the command `puppet module install puppetlabs/postgresqldb`
 * Conzar/reset_apt module.  Can be obtained here: http://forge.puppetlabs.com/conzar/reset_apt or with the command `puppet module install conzar/reset_apt`

## Configuration

There is one class (ckan) that needs to be declared.  The class installs and manages a single instance of tomcat6.  The tomcat6 class is a paramaterized class with 1 optional paramater.
There is one defined type called tomcat6::app.  The tomcat6::app defines a webapp to be installed into the typical webapp directory of tomcat.  

### Tomcat6 Optional Parameter

The parameters listed in this section can optionally be configured.

#### `resources`
Tomcat6 static resources defined in the context.xml file.  More details about the configuraiton can be found [here](http://tomcat.apache.org/tomcat-6.0-doc/config/resources.html).
 This variable is an array of hashes.  Valid hash values defined below.
  * name
  * auth
  * type
  * driverClassName
  * url
  * username
  * password
  * maxActive
  * minIdle
  * maxIdle
  * maxWait
  * minEvictableIdleTimeMillis
  * timeBetweenEvictionRunsMillis
  * numTestsPerEvictionRun
  * poolPreparedStatements
  * maxOpenPreparedStatements
  * testOnBorrow
  * accessToUnderlyingConnectionAllowed
  * validationQuery


## Usage

This section shows example uses of the tomcat6 module.

### Example 1
This example demonstrates the most basic usage of the tomcat6 module.
Deploys tomcat6 with the default configuration.

	class {'tomcat6': }

### Example 2
This example demonstrates a static resource type configured for a web app called pidsvc.

Declaring a hash for the static resource.
  $tomcat_resources = {
    pidsvc => {
			'name' => 'jdbc/pidsvc',
			'auth' => 'Container',
			'type' => 'javax.sql.DataSource',
			'driverClassName' => 'org.postgresql.Driver',
			'url' => "jdbc:postgresql://$pidservice::servername:5432/pidsvc",
			'username' => "$pidservice::db_user",
			'password' => "$pidservice::db_passwd",
			'maxActive' => '-1',
			'minIdle' => '0',
			'maxIdle' => '10',
			'maxWait' => '10000',
			'minEvictableIdleTimeMillis' => '300000',
			'timeBetweenEvictionRunsMillis' => '300000',
			'numTestsPerEvictionRun' => '20',
			'poolPreparedStatements' => 'true',
			'maxOpenPreparedStatements' => '100',
			'testOnBorrow' => 'true',
			'accessToUnderlyingConnectionAllowed' => 'true',
			'validationQuery' => 'SELECT VERSION();'
    }
  }
  
Declaring tomcat6 with the resoures.
  class { 'tomcat6': 
    resources => $tomcat_resources,
  }

Declaring an app that eventually utilizes the static resource.
  tomcat6::app{'pidsvc':
    war_url => 'https://cgsrv1.arrc.csiro.au/swrepo/PidService/jenkins/trunk/pidsvc-latest.war',
    jar_lib_url => 'http://jdbc.postgresql.org/download/postgresql-9.3-1100.jdbc4.jar',
  }

## License

GPL version 3

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, [see](http://www.gnu.org/licenses/).
