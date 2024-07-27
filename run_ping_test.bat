@echo off
echo 开始运行...
echo 加载测试脚本...
echo 加载最新主机...
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
