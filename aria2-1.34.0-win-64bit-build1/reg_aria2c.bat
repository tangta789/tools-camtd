@echo off
chcp 936 > NUL

set regpath=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run

%1 %2
echo reg query %regpath%
reg query %regpath% /v aria2c >NUL 2>NUL && (
	call :CALL_RUN
	exit
)

ver|find "5.">NUL && goto :REG

mshta VBScript:CreateObject("Shell.Application").ShellExecute("%~s0","goto :REG","","runas",1)(window.close)
exit

:REG
echo Register aria2c...
reg add %regpath% /v aria2c /t REG_SZ /d "\"%~s0\"" /f
rem %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
echo Register successfully!
pause
goto :eof

:UNREG
reg delete %regpath% /v aria2c /f
goto :eof

:CALL_RUN
mshta VBScript:CreateObject("Wscript.Shell").Run("%~s0 goto :RUN",vbHide)(window.close)
goto :eof

:RUN
echo Run aria2c...
taskkill /f /im aria2c.exe
"%~dp0aria2c.exe" --enable-rpc --rpc-listen-all=true --rpc-allow-origin-all -D
goto :eof