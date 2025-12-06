create() {
  database=$1
  username=$2
  password=$3
  db_options=${4:-}
  
    kubectl exec deployment/postgres -- env PGPASSWORD=${password} psql --user=postgres -c "DROP DATABASE IF EXISTS \"${database}\";"
  kubectl exec deployment/postgres -- env PGPASSWORD=${password} psql --user=postgres -c "DROP ROLE IF EXISTS \"${username}\";"

  kubectl exec deployment/postgres -- env PGPASSWORD=${password} psql --user=postgres -c "CREATE ROLE ${username} WITH PASSWORD '${password}' LOGIN;"
  kubectl exec deployment/postgres -- env PGPASSWORD=${password} psql --user=postgres -c "CREATE DATABASE \"${database}\" WITH OWNER ${username};"

  echo "Created database ${database} and create + assign user ${username}"
}

create "ory-hydra" "hydra" "banana"