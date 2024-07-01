kubectl exec deployment/rabbitmq -- rabbitmqctl add_vhost /faf-core
kubectl exec deployment/rabbitmq -- rabbitmqctl add_user faf-api banana
kubectl exec deployment/rabbitmq -- rabbitmqctl set_permissions -p /faf-core faf-api ".*" ".*" ".*" 
