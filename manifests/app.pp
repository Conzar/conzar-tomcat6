# == Class: tomcat6::app
#
# Creates a new app with the name of the app is the title of this defined type.
# An app is deployed through a war file.
#
# === Parameters
#
# [*war_url*] The url that points to the war to download.
# [*jar_lib_url*] An additional jar to install to the app (usually a jdbc driver).
#
# === Variables
#
# [*fetch_name*] Used as the name of the task for downloading the war file.
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
define tomcat6::app (
  $war_url,
  $jar_lib_url = undef,
){

  $fetch_name = "download $title"

  include wget
  # install the war
  wget::fetch {$fetch_name:
    source => $war_url,
    destination => "$tomcat6::tomcat_webapps/$title.war",
    timeout => 0,
    verbose     => false,
    notify => Service['tomcat6'],
    require => [File[$tomcat6::tomcat_webapps]],
  }
  
  #unzip war
  include check_run
  $task_unzip = "task_unzip_$title"
  check_run::task{$task_unzip:
    exec_command  => "/usr/bin/unzip -d $tomcat6::tomcat_webapps/$title $tomcat6::tomcat_webapps/$title.war",
    require       => Wget::Fetch[$fetch_name],
  }
  
  # make sure the directory to store the jdbc driver exists
  file {["$tomcat6::tomcat_webapps/$title",
         "$tomcat6::tomcat_webapps/$title/WEB-INF",
         "$tomcat6::tomcat_webapps/$title/WEB-INF/lib"]:
    ensure => directory,
    require => [Wget::Fetch [$fetch_name],Check_run::Task[$task_unzip]],
  }
    
  # download the necessary jdbc driver
  if $jar_lib_url != undef {
    $lib_name_array = split($jar_lib_url,"/")
    $lib_name = $lib_name_array[-1]
    wget::fetch {$jar_lib_url:
      destination => "$tomcat6::tomcat_webapps/$title/WEB-INF/lib/$lib_name",
      require => [Wget::Fetch [$fetch_name],
                  File["$tomcat6::tomcat_webapps/pidsvc/WEB-INF/lib"],
                  Check_run::Task[$task_unzip]],
      timeout => 0,
      verbose => false,
    }
  }
}