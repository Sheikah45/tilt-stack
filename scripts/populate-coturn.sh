statements=$(cat sql/test-coturn.sql)
kubectl exec deployment/faf-db -- mysql --user=root --password= faf-ice-breaker --execute="$statements"