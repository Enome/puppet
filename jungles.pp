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

exec { 'startup':
  command => '/usr/bin/curl https://raw.github.com/Enome/startup/master/bin/startup > /usr/local/bin/startup',
}

exec { 'startup executable':
  command => '/bin/chmod +x /usr/local/bin/startup',
  require => Exec['startup']
}

package { 'postgresql': }
package { 'git': }
package { 'build-essential': }

exec { 'iptables':
  command => '/sbin/iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000 -v'
}
