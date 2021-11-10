class bludit_upload_images_exec::apache {
  $secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $port = $secgen_parameters['port'][0]
  $docroot = '/var/www/bludit-3-9-2'

  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  ensure_resource('tidy','gl remove default site', {'path'=>'/etc/apache2/sites-enabled/000-default.conf'})

  class { '::apache':
    default_vhost => false,
    default_mods => ['rewrite'], # php5 via separate module
    overwrite_ports => false,
    mpm_module => 'prefork'
  } ->

  ::apache::vhost { 'www-bludit':
    port    => $port,
    docroot => $docroot,
  } ->


  # restart apache
  exec { 'restart-apache-bludit':
    command => 'service apache2 restart',
    logoutput => true
  } ->
  exec { 'wait-apache-bludit':
    command => 'sleep 4',
  }
}
