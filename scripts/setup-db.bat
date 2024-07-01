@echo off

rem Call the create function with the necessary arguments
call :CREATE %1 "faf" "faf-java-api" "banana"
call :CREATE %1 "faf" "faf-python-api" "banana"
call :CREATE %1 "faf" "faf-aio-replayserver" "banana"
call :CREATE %1 "faf" "faf-policy-server" "banana"
call :CREATE %1 "faf" "faf-python-server" "banana"
call :CREATE %1 "faf" "faf-user-service" "banana"
call :CREATE %1 "faf-wordpress" "faf-wordpress" "banana"
call :CREATE %1 "faf_league" "faf-java-api" "banana"
call :CREATE %1 "faf_league" "faf-league-service" "banana"
call :CREATE %1 "hydra" "hydra" "banana" "CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci"
call :CREATE %1 "ergochat" "ergochat" "banana"

goto :EOF

rem Function to create database and user
:CREATE
set "pod=%~1"
set "database=%~2"
set "username=%~3"
set "password=%~4"
set "db_options=%~5"

echo Create database %database% and create + assign user %username%

kubectl exec %pod% -- mysql --user=root --password= --execute="CREATE DATABASE IF NOT EXISTS `%database%` %db_options%; CREATE USER IF NOT EXISTS '%username%'@'%%' IDENTIFIED BY '%password%'; GRANT ALL PRIVILEGES ON `%database%`.* TO '%username%'@'%%';"
goto :EOF

:EOF