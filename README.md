# Puppet DISM Type/Provider

Windows Deployment Image Servicing and Management (DISM.exe) is used to enable or disable Windows features on Windows 7, Windows Server 2008 R2.

http://technet.microsoft.com/en-us/library/dd744582(v=ws.10).aspx

# Usage:

    dism { 'NetFx3':
      ensure => enabled,
    }

    dism { 'IIS-WebServer':
      ensure => enabled,
      answer => 'C:\answer\iis.xml',
    }
