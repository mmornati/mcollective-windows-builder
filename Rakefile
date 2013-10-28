require 'rake'
require 'fileutils'
include FileUtils
require 'net/http'

# set constant values:
LIB_FOLDER = File.expand_path('./lib')
INSTALL_FOLDER = File.expand_path('./install')
ISCC = "C:/Programmi/Inno Setup 5/iscc.exe"
ISS_FILE = "#{INSTALL_FOLDER}/Setup.iss"

APP_TITLE = "Marionette Collective"
EXE_NAME = "mcollective"
EXE_BASENAME = "mcollective"
APP_VERSION = "2.3.2"

#functions
def download_gem(url,filename,opt={})
  opt = {
    :init_pause => 0.1,    #start by waiting this long each time
                           # it's deliberately long so we can see 
                           # what a full buffer looks like
    :learn_period => 0.3,  #keep the initial pause for at least this many seconds
    :drop_factor => 1.5,          #fast reducing factor to find roughly optimized pause time
    :adjust => 1.05        #during the normal period, adjust up or down by this factor
  }.merge(opt)
  pause = opt[:init_pause]
  learn = 1 + (opt[:learn_period]/pause).to_i
  drop_period = true
  delta = 0
  max_delta = 0
  last_pos = 0
  File.open("#{INSTALL_FOLDER}/gems/#{filename}",'wb'){ |f|
    uri = URI.parse(url)
    Net::HTTP.start(uri.host,uri.port){ |http|
      http.request_get(uri.path){ |res|
        res.read_body{ |seg|
		  unless seg.nil?
			  f << seg
			  delta = f.pos - last_pos
			  last_pos += delta
			  if delta > max_delta then max_delta = delta end
			  if learn <= 0 then
				learn -= 1
			  elsif delta == max_delta then
				if drop_period then
				  pause /= opt[:drop_factor]
				else
				  pause /= opt[:adjust]
				end
			  elsif delta < max_delta then
				drop_period = false
				pause *= opt[:adjust]
			  end
			  sleep(pause)
		  end
        }
      }
    }
  }
  puts "#{filename} downloaded!"
end

# rake tasks:
task :default => [:create_setup]

desc "Create setup.exe"
task :create_setup => [:create_iss_script] do
    puts "Creating setup.exe"
    Dir.chdir(INSTALL_FOLDER)
    system(ISCC, ISS_FILE)
end

desc "Create ISS script"
task :create_iss_script => [:copy_files, :change_configuration, :download_gems] do
    puts "Creating ISS script"
    Dir.chdir(INSTALL_FOLDER)
    data = ISS_TEXT.gsub('[APP_TITLE]', APP_TITLE).gsub('[APP_VERSION]', APP_VERSION).gsub('[EXE_NAME]', EXE_NAME).gsub('[EXE_BASENAME]', EXE_BASENAME)
    File.open(ISS_FILE, 'w') do |f|
        f.puts(data)
    end
end

desc "Copy required files"
task :copy_files => [:create_target_dir] do
    puts "Copying required file to install folder"
	FileUtils.cp_r 'bin', INSTALL_FOLDER
	FileUtils.cp_r 'doc', INSTALL_FOLDER
	FileUtils.cp_r 'etc', INSTALL_FOLDER
	FileUtils.cp_r 'ext', INSTALL_FOLDER
	FileUtils.cp_r 'lib', INSTALL_FOLDER
	FileUtils.cp_r 'plugins', INSTALL_FOLDER
end

desc "Download required gems"
task :download_gems => [] do
    puts "Downloading required gems files"
	download_gem('http://production.cf.rubygems.org/gems/stomp-1.2.2.gem', 'stomp-1.2.2.gem')
	download_gem('http://production.cf.rubygems.org/gems/win32-process-0.6.5.gem', 'win32-process-0.6.5.gem')
	download_gem('http://production.cf.rubygems.org/gems/win32-service-0.7.2-x86-mingw32.gem', 'win32-service-0.7.2.gem')
	download_gem('http://production.cf.rubygems.org/gems/sys-admin-1.5.6-x86-mingw32.gem', 'sys-admin-1.5.6.gem')
	download_gem('http://production.cf.rubygems.org/gems/windows-api-0.4.1.gem', 'windows-api-0.4.1.gem')
	download_gem('http://production.cf.rubygems.org/gems/windows-pr-1.2.1.gem', 'windows-pr-1.2.1.gem')
	download_gem('http://production.cf.rubygems.org/gems/win32-security-0.1.2.gem', 'win32-security-0.1.2.gem')
	download_gem('http://production.cf.rubygems.org/gems/win32-api-1.4.8-x86-mingw32.gem', 'win32-api-1.4.8.gem')
	download_gem('http://production.cf.rubygems.org/gems/ffi-1.9.0.gem', 'ffi-1.9.0.gem')
	download_gem('http://production.cf.rubygems.org/gems/win32-dir-0.4.6.gem', 'win32-dir-0.4.6.gem')
end

desc "Create Configuration File"
task :change_configuration => [] do
    puts "Creating required configuration file"
	FileUtils.cp_r 'etc/client.cfg.dist', "#{INSTALL_FOLDER}/etc/client.cfg"
	FileUtils.cp_r 'etc/server.cfg.dist', "#{INSTALL_FOLDER}/etc/server.cfg"
	FileUtils.cp_r 'etc/facts.yaml.dist', "#{INSTALL_FOLDER}/etc/facts.yaml"
end


desc "Create Target Dir"
task :create_target_dir => [] do
    puts "Create Target Dir"
	if File.exists?(INSTALL_FOLDER) && File.directory?(INSTALL_FOLDER)
		FileUtils.rm_rf INSTALL_FOLDER
	end
	Dir.mkdir(INSTALL_FOLDER, 0700) #=> 0
	Dir.mkdir("#{INSTALL_FOLDER}/gems", 0700) #=> 0
end

# text of Inno Setup script:
ISS_TEXT =<<-END_OF_ISS

[Setup]
AppName=[APP_TITLE]
AppVerName=[APP_TITLE] version [APP_VERSION]
AppPublisher=Marco Mornati
AppPublisherURL=http://www.mornati.net
AppContact=ilmorna@gmail.com
AppVersion=[APP_VERSION]
DefaultDirName=C:\\[EXE_NAME]
DefaultGroupName=[APP_TITLE]
UninstallDisplayIcon={app}\\[EXE_NAME]
Compression=lzma
SolidCompression=yes
OutputDir=.
OutputBaseFilename="[EXE_BASENAME]_Setup"

[Files]
Source: "bin/*"; DestDir: "{app}/bin"; Flags: recursesubdirs
Source: "doc/*"; DestDir: "{app}/doc"; Flags: recursesubdirs
Source: "etc/*"; DestDir: "{app}/etc"; Flags: recursesubdirs
Source: "ext/*"; DestDir: "{app}/ext"; Flags: recursesubdirs
Source: "lib/*"; DestDir: "{app}/lib"; Flags: recursesubdirs
Source: "gems/*"; DestDir: "{app}/gems"; Flags: recursesubdirs
Source: "plugins/*"; DestDir: "{app}/plugins"; Flags: recursesubdirs
Source: "ext/windows/*"; DestDir: "{app}/bin"; Flags: ignoreversion

[Run]
Filename: "{app}/bin/install_gems.bat"; Description: "Install Gems File"; Flags: postinstall shellexec waituntilterminated
Filename: "{app}/bin/register_service.bat"; Description: "Register Mcollective as a service"; Flags: postinstall shellexec

[UninstallRun]
Filename: "{app}/bin/unregister_service.bat"; Flags: shellexec

[Code]
var
	ConfigValues:	TArrayOfString;

function ConfigReadFile (FileName: String): Boolean;
begin
	Result := LoadStringsFromFile (FileName, ConfigValues);
end;

function ConfigQueryValue (ValueName: String; var Value: String): Boolean;
var
	I:		LongInt;
	L:		LongInt;
	S:		String;
begin
	S := ValueName + ' = ';
	L := Length (S);
	For I := 0 to GetArrayLength (ConfigValues) - 1 do
	begin
		if (copy (ConfigValues [I], 1, L) = S) then
		begin
			Value := copy (ConfigValues [I], L + 1,
				Length (ConfigValues [I]) - L);
			Result := TRUE;
			Exit;
		end;
	end;
	Result := FALSE;
end;

function ConfigWriteValue (ValueName: String; Value: String): Boolean;
var
	I:		LongInt;
	L:		LongInt;
	A:		LongInt;
	S:		String;
begin
	S := ValueName + ' = ';
	L := Length (S);
	A := GetArrayLength (ConfigValues);
	For I := 0 to A - 1 do
	begin
		if (copy (ConfigValues [I], 1, L) = S) then
		begin
			ConfigValues [I] := S + Value;
			Result := TRUE;
			Exit;
		end;
	end;
	SetArrayLength (ConfigValues, A + 1);
	ConfigValues [A] := S + Value;
	Result := FALSE;
end;

function ConfigWriteFile (FileName: String): Boolean;
var
	bRet:	Boolean;
begin
	// FileName -> Backup.
	bRet := FileCopy (FileName,
		ExpandConstant ('{tmp}\' + ExtractFileName (FileName)),
		FALSE);
	if (bRet) then
	begin
		bRet := SaveStringsToFile (FileName, ConfigValues, FALSE);
		if (bRet) then
		begin
			Result := TRUE;
			Exit;
		end else
		begin
			// Maybe the backup file should be copied back here?
		end;
	end;
	Result := FALSE;
end;

procedure CurStepChanged (CurStep: TSetupStep);
begin
	if (CurStep = ssPostInstall) then
	begin
		ConfigReadFile (ExpandConstant('{app}/etc/client.cfg'));
		ConfigWriteValue ('libdir', ExpandConstant('{app}\\plugins'));
		ConfigWriteValue ('plugin.yaml', ExpandConstant('{app}\\etc\\facts.yaml'));
		ConfigWriteFile (ExpandConstant('{app}/etc/client.cfg'));
		
		ConfigReadFile (ExpandConstant('{app}/etc/server.cfg'));
		ConfigWriteValue ('libdir', ExpandConstant('{app}\\plugins'));
		ConfigWriteValue ('logfile', ExpandConstant('{app}\\mcollective.log')); 
		ConfigWriteValue ('plugin.yaml', ExpandConstant('{app}\\etc\\facts.yaml'));
		ConfigWriteFile (ExpandConstant('{app}/etc/server.cfg'));
	end;
end;

[Icons]
Name: "{group}\\[APP_TITLE]"; Filename: "{app}\\[EXE_NAME]"; WorkingDir: "{app}"
Name: "{group}\\View ReadMe File"; Filename: "{app}\\ReadMe.txt"; WorkingDir: "{app}"

END_OF_ISS