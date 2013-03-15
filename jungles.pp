# Node.js

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


# Startup

exec { 'startup':
  command => '/usr/bin/curl https://raw.github.com/Enome/startup/master/bin/startup > /usr/local/bin/startup',
}

exec { 'startup executable':
  command => '/bin/chmod +x /usr/local/bin/startup',
  require => Exec['startup']
}

# Git
package { 'git': }


# G++ for unicode module (slug)

package { 'build-essential': }


# Iptables

exec { 'iptables':
  command => '/sbin/iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000 -v'
}


# Firewall

package { 'ufw': }

exec { 'ufw-setup':
  command => '/usr/sbin/ufw allow ssh && /usr/sbin/ufw allow ssh && /usr/sbin/ufw allow 80 && /usr/sbin/ufw allow 3000 && /usr/sbin/ufw --force enable',
  require => Package['ufw']
}


# Postgres

class {'postgresql::server': 
  listen => ['localhost',],
  acl => ['local all all trust', ],
}

postgresql::db { 'jungles':
  password => '1234',
  owner => 'jungles',
  require => Service['postgresql-system-9.1'],
}


# Fingerprint bitbucket

exec { 'fingerprint':
  command => '/usr/bin/ssh -o StrictHostKeyChecking=no bitbucket.org'
}
