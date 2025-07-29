@echo off
setlocal

set RESTART_DELAY=5

:restart
cls

echo Starting Rust server...
echo.

.\RustDedicated.exe -batchmode -nographics ^
    +server.ip "0.0.0.0" ^
    +server.port 28015 ^
    +server.tickrate 10 ^
    +server.hostname "My Rust Server!" ^
    +server.identity "server01" ^
    +server.level "Procedural Map" ^
    +server.seed 793197 ^
    +server.maxplayers 200 ^
    +server.worldsize 600 ^
    +rcon.ip 0.0.0.0 ^
    +rcon.port 28016 ^
    +rcon.password "test1234"

echo.
echo Detected server stop or crash. Restarting in %RESTART_DELAY% seconds...

timeout /t %RESTART_DELAY% /nobreak > nul

goto restart