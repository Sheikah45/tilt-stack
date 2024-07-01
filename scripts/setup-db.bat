@echo off

rem Call the create function with the necessary arguments
call :CREATE "faf" "faf-java-api" "banana"
call :CREATE "faf" "faf-python-api" "banana"
call :CREATE "faf" "faf-aio-replayserver" "banana"
call :CREATE "faf" "faf-policy-server" "banana"
call :CREATE "faf" "faf-python-server" "banana"
call :CREATE "faf" "faf-user-service" "banana"
call :CREATE "faf-wordpress" "faf-wordpress" "banana"
call :CREATE "faf_league" "faf-java-api" "banana"
call :CREATE "faf_league" "faf-league-service" "banana"
call :CREATE "hydra" "hydra" "banana" "CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci"
call :CREATE "ergochat" "ergochat" "banana"

goto :EOF

rem Function to create database and user
:CREATE
set "database=%~1"
set "username=%~2"
set "password=%~3"
set "db_options=%~4"

echo Create database %database% and create + assign user %username%

kubectl exec deployment/faf-db -- mysql --user=root --password= --execute="CREATE DATABASE IF NOT EXISTS `%database%` %db_options%; CREATE USER IF NOT EXISTS '%username%'@'%%' IDENTIFIED BY '%password%'; GRANT ALL PRIVILEGES ON `%database%`.* TO '%username%'@'%%';"
goto :EOF

:EOF