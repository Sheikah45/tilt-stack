#!/usr/bin/env bash
#!/bin/bash

create() {
  pod=$1
  database=$2
  username=$3
  password=$4
  db_options=${5:-}

  echo "Create database ${database} and create + assign user ${username}"

  kubectl exec $pod -- mysql --user=root --password= <<SQL_SCRIPT
    CREATE DATABASE IF NOT EXISTS \`${database}\` ${db_options};
    CREATE USER IF NOT EXISTS '${username}'@'%' IDENTIFIED BY '${password}';
    GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${username}'@'%';
SQL_SCRIPT
}

create $1 "faf" "faf-java-api" "banana"
create $1 "faf" "faf-python-api" "banana"
create $1 "faf" "faf-aio-replayserver" "banana"
create $1 "faf" "faf-policy-server" "banana"
create $1 "faf" "faf-python-server" "banana"
create $1 "faf" "faf-user-service" "banana"
create $1 "faf-wordpress" "faf-wordpress" "banana"
create $1 "faf_league" "faf-java-api" "banana"
create $1 "faf_league" "faf-league-service" "banana"
create $1 "hydra" "hydra" "banana" "CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci"
create $1 "ergochat" "ergochat" "banana"