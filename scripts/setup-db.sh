#!/usr/bin/env bash
#!/bin/bash

create() {
  database=$1
  username=$2
  password=$3
  db_options=${4:-}

  echo "Create database ${database} and create + assign user ${username}"

  kubectl exec deployment/faf-db -- mysql --user=root --password= <<SQL_SCRIPT
    CREATE DATABASE IF NOT EXISTS \`${database}\` ${db_options};
    CREATE USER IF NOT EXISTS '${username}'@'%' IDENTIFIED BY '${password}';
    GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${username}'@'%';
SQL_SCRIPT
}

create "faf" "faf-java-api" "banana"
create "faf" "faf-python-api" "banana"
create "faf" "faf-aio-replayserver" "banana"
create "faf" "faf-policy-server" "banana"
create "faf" "faf-python-server" "banana"
create "faf" "faf-user-service" "banana"
create "faf-wordpress" "faf-wordpress" "banana"
create "faf_league" "faf-java-api" "banana"
create "faf_league" "faf-league-service" "banana"
create "hydra" "hydra" "banana" "CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci"
create "ergochat" "ergochat" "banana"