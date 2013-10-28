mcollective-windows-builder
===========================

Builder script to create a Windows Package for MCollective project
(http://docs.puppetlabs.com/mcollective/).

This builder requirs:
* A Windows Machine (:P)
* InnoSetup (http://www.jrsoftware.org/isinfo.php)
* Ruby 1.8.7+
* Ruby utils into PATH environment variable

Configuration
-------------
Before to start your build you should check if all parameters in the *Rakefile*
are correct for your build environment.
All the parameters are at the beginning of the file:

```ruby
# set constant values:
LIB_FOLDER = File.expand_path('./lib')
INSTALL_FOLDER = File.expand_path('./install')
ISCC = "C:/Programmi/Inno Setup 5/iscc.exe"
ISS_FILE = "#{INSTALL_FOLDER}/Setup.iss"

APP_TITLE = "Marionette Collective"
EXE_NAME = "mcollective"
EXE_BASENAME = "mcollective"
APP_VERSION = "2.3.2"
```

The two most important variables are:
* ISCC: with the path to the InnoSetup exe file
* APP_VERSION: With the version you are trying to build


Prepare the build
-----------------
* You have to download the Mcollective sources you need to package for windows
(http://downloads.puppetlabs.com/mcollective/).
* Then extract the tgz package download in the desired location.
* Copy the Rakefile into the sources root folder
* Copy the *install_gems.bat* file into */bin* subfolder
* Execute Rake

Operation Executed during the build
-----------------------------------
The build procedure will then start and it accomplishes this tasks:
* Download all required gem dependencies
* Create an InnoSetup build script
* Execute InnoSetup packaging MCollective sources and gems
