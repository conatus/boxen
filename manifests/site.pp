require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $luser,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::luser}"
  ]
}

File {
  group => 'staff',
  owner => $luser
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => Class['git']
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # Core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx
  include nvm

  # Node versions
  include nodejs::0-4
  include nodejs::0-6
  include nodejs::0-8

  # Ruby versions
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0

  # Development
  include virtualbox
  include vagrant
  include sublime_text_2
  include sequel_pro
  include github
  include java
  include sourcetree

  # Browsers
  include chrome
  include chrome::canary
  include firefox

  # Web utilities
  include cyberduck
  include wget

  # Communication
  include hipchat
  include colloquy
  include skype

  # Music
  include spotify

  # Productivity
  include wunderlist
  include alfred
  include dropbox
  include lastpass
  include divvy

  # Video
  include vlc

  # Other
  include flux
  include appcleaner
  include kindle
  include unarchiver
  include caffeine

  class { 'intellij':
    edition => 'ultimate',
  }

  # Common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'git-extras',
      'tree',
      'haskell-platform',
      's3cmd',
      'phantomjs'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
