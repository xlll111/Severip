@echo off
echo ��ʼ����...
echo ���ز��Խű�...
echo ������������...
setlocal enabledelayedexpansion
set "urlPingTest=https://xlll111.github.io/Severip/ping_test.ps1"
set "urlHosts=https://xlll111.github.io/Severip/host.txt"
powershell -Command "Invoke-WebRequest -Uri !urlPingTest! -OutFile '%~dp0ping_test.ps1'"
powershell -Command "Invoke-WebRequest -Uri !urlHosts! -OutFile '%~dp0host.txt'"
set "tempFilePathPingTest=%~dp0ping_test.ps1"
set "tempFilePathHosts=%~dp0host.txt"
powershell -Command "& '%tempFilePathPingTest%'"
del "%tempFilePathPingTest%"
del "%tempFilePathHosts%"
pause
endlocal
