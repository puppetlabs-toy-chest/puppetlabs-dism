##2018-11-1 - Release 1.3.1

###Summary

A bug was introduced in 1.3.0 that broke the module. This is a patch release to
fix the module.

- Incorrectly scoped functions ([MODULES-8199](https://tickets.puppetlabs.com/browse/MODULES-8199))

##2018-10-29 - Release 1.3.0

###Summary

Minor bufixes and adds support for Windows Server 2016, Windows 10, Puppet 5, and Puppet 6

###Features
- Metadata for supporting Windows Server 2016 and Windows 10 ([MODULES-4271](https://tickets.puppetlabs.com/browse/MODULES-4271))
- Convert module to PDK format ([MODULES-7048](https://tickets.puppetlabs.com/browse/MODULES-7048))
- Add support for Puppet 5 and 6 ([MODULES-7833](https://tickets.puppetlabs.com/browse/MODULES-7833))

###Bugfixes
- DISM fails on windows when source parameter specified ([MODULES-2917](https://tickets.puppetlabs.com/browse/MODULES-2917))

##2015-09-01 - Release 1.2.0
###Summary

Add source and limitaccess parameters to allow for local offline install

###Features
- All runs now will run with /Quiet
- Munge truthy and falsy values to be of type boolean
- Add source param to allow for local access source
- Add limitaccess parameter

###Bugfixes
- Remove legacy ensurable block to ensure compatibility with Puppet 4.x

##2014-11-25 - Release 1.1.0
###Summary

Add the ability to specify NoRestart (MODULES-1389)

##2014-08-06 - Release 1.0.0
###Summary

Preparing for Puppet 3.7 and x64 Ruby, refacter dism executable lookup and
refactored to only look for resource once.

##2014-07-15 - Release 0.2.1
###Summary

This release merely updates metadata.json so the module can be uninstalled and
upgraded via the puppet module command.

##2014-06-18 - Release 0.2.0
###Features
- Added 'all' parameter to indicate whether or not all dependencies should be
installed
- Add support for additional exit codes
- Add workaround for https://bugs.ruby-lang.org/issues/8083
- Add Apache 2.0 License

###Bugfixes
- Documentation typo fix
