#!/bin/sh

kubectl exec statefulset/rabbitmq -- rabbitmqctl add_vhost //faf-core
kubectl exec statefulset/rabbitmq -- rabbitmqctl add_user faf-api banana
kubectl exec statefulset/rabbitmq -- rabbitmqctl set_permissions -p //faf-core faf-api ".*" ".*" ".*" 
kubectl exec statefulset/rabbitmq -- rabbitmqctl add_user faf-python-server banana
kubectl exec statefulset/rabbitmq -- rabbitmqctl set_permissions -p //faf-core faf-python-server ".*" ".*" ".*" 
kubectl exec statefulset/rabbitmq -- rabbitmqctl add_user faf-league-service banana
kubectl exec statefulset/rabbitmq -- rabbitmqctl set_permissions -p //faf-core faf-league-service ".*" ".*" ".*" 