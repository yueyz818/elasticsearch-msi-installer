@echo off
cd %~dp0
call esi_config.bat
elasticsearch.bat %*