gem list --local | findstr stomp
if errorlevel 1 call gem install ../gems/stomp
gem list --local | findstr win32-api
if errorlevel 1 call gem install ../gems/win32-api
gem list --local | findstr windows-api
if errorlevel 1 call gem install ../gems/windows-api
gem list --local | findstr windows-pr
if errorlevel 1 call gem install ../gems/windows-pr
gem list --local | findstr win32-security
if errorlevel 1 call gem install ../gems/win32-security
gem list --local | findstr sys-admin
if errorlevel 1 call gem install ../gems/sys-admin
gem list --local | findstr win32-process
if errorlevel 1 call gem install ../gems/win32-process
gem list --local | findstr win32-service
if errorlevel 1 call gem install ../gems/win32-service
gem list --local | findstr ffi
if errorlevel 1 call gem install ../gems/ffi
gem list --local | findstr win32-dir
if errorlevel 1 call gem install ../gems/win32-dir

