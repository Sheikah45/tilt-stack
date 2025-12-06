#!/bin/sh

statements=$(cat $1)
kubectl exec deployment/faf-db -- mariadb --user=root --password= faf --execute="$statements"