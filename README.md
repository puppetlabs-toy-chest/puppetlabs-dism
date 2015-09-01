# dism

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with dism](#setup)
    * [What dism affects](#what-dism-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview
The dism module enables and disables Windows Features using the DISM utility provided by Microsoft

##Module Description

This module provides a `dism` puppet resource type on Windows. Windows Deployment Image Servicing and Management (DISM.exe)
 is used to enable or disable Windows features on Windows 7 SP1, Windows 8,  Windows Server 2008 R2, Windows Server 2012, Windows 2012 R2

[Enable or Disable Windows Features](http://technet.microsoft.com/en-us/library/dd744582.aspx)
[What is DISM?](http://technet.microsoft.com/en-us/library/hh825236.aspx)

##Setup

###What dism affects
`dism` will modify the existing features on the system, whether enabling or disabling. In some instances the server will
be restarted unless explicity setting the parameter `norestart` to `true`

###Setup Requirements
The module requires that dism be installed on your system, in most cases this will be there by default.  In some cases,
  such as Windows 7 it requires SP1 or to be manually installed.

##Usage
###To enable DotNet3 and all child settings
~~~ puppet
dism { 'NetFx3':
  ensure => present,
  all    => true,
  source => 'Z:\2012r2\sxs'
}
~~~

###To install IIS and provide an answer file for all setup steps
~~~ puppet
dism { 'IIS-WebServer':
  ensure => present,
  answer => 'C:\answer\iis.xml',
}
~~~

###To disable Internet Explorer and prevent restart
~~~ puppet
dism { 'Internet-Explorer-Optional-amd64':
  ensure    => absent,
  norestart => true,
}
~~~

##Reference

###Types

#### dism
* `ensure`: Ensures that the feature is enabled or disabled.  Valid values are 'present' or 'absent'.
* `name`: The name of the feature you would like to modify.  This defaults to the title being passed
* `all`: Whether to install all child features.  Defaults to false
* `answer`: The answer file that you would like to pass to dism.exe to provide any answers.
* `norestart`: Whether to explicitly tell the provider to NOT restart.  Defaults to false.
* `exitcodes`: Acceptable exit codes. Defaults to [0, 3010]
* `source`: Filepath to the source files needed for installing the feature.
* `limitaccess`: Prevent DISM from contacting WU for repair of online images. Defaults to false
