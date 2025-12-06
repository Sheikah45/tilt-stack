#!/bin/sh

statements=$(cat sql/test-coturn.sql)
kubectl exec deployment/faf-db -- mariadb --user=root --password= faf-ice-breaker --execute="$statements"