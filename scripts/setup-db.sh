#!/bin/sh

create() {
  database=$1
  username=$2
  password=$3
  db_options=${4:-}

  kubectl exec deployment/faf-db -- mariadb --user=root --password= -e "CREATE DATABASE IF NOT EXISTS \`${database}\` ${db_options};"
  kubectl exec deployment/faf-db -- mariadb --user=root --password= -e "CREATE USER IF NOT EXISTS '${username}'@'%' IDENTIFIED BY '${password}';"
  kubectl exec deployment/faf-db -- mariadb --user=root --password= -e "GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${username}'@'%';"

  echo "Created database ${database} and create + assign user ${username}"
}

create "faf" "faf-java-api" "banana"
create "faf" "faf-python-api" "banana"
create "faf" "faf-replay-server" "banana"
create "faf" "faf-policy-server" "banana"
create "faf" "faf-python-server" "banana"
create "faf" "faf-user-service" "banana"
create "faf-ice-breaker" "faf-ice-breaker" "banana"
create "faf-wordpress" "faf-wordpress" "banana"
create "faf-league" "faf-java-api" "banana"
create "faf-league" "faf-league-service" "banana"
create "ergochat" "ergochat" "banana"