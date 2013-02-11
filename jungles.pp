package { 'software-properties-common': }

exec { 'node repo': 
  command => '/usr/bin/apt-add-repository ppa:chris-lea/node.js',
  require => Package['software-properties-common']
}

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
  require => Exec['node repo']
}

package { 'nodejs':
  require => Exec['apt-get update']
}

package { 'npm':
  require => Exec['apt-get update']
}

exec { 'startup':
  command => '/usr/bin/curl https://raw.github.com/Enome/startup/master/bin/startup > /usr/local/bin/startup',
}

package { 'postgresql': }
package { 'git': }
