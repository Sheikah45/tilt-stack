k8s_yaml("deploy/mariadb.yaml")
k8s_yaml("deploy/rabbitmq.yaml")
k8s_yaml("deploy/ory-hydra.yaml")
k8s_yaml("deploy/faf-user-service.yaml")
k8s_yaml("deploy/faf-api.yaml")

local_resource(name = "setup-db", cmd = [os.path.abspath("scripts/setup-db.sh")], cmd_bat = [os.path.abspath("scripts/setup-db.bat")], resource_deps=["faf-db"])
local_resource(name = "setup-rabbitmq", cmd = [os.path.abspath("scripts/setup-rabbitmq.sh")], cmd_bat = [os.path.abspath("scripts/setup-rabbitmq.bat")], resource_deps=["rabbitmq"])
local_resource(name = "setup-hydra-clients", cmd = [os.path.abspath("scripts/setup-hydra-clients.sh")], cmd_bat = [os.path.abspath("scripts/setup-hydra-clients.bat")], resource_deps=["ory-hydra"])

k8s_resource(workload='faf-db', port_forwards="3306")
k8s_resource(workload="faf-db-migrate", resource_deps=["setup-db"])
k8s_resource(workload='ory-hydra-migrate', objects=["ory-hydra:configmap"], resource_deps=["faf-db"])
k8s_resource(workload='ory-hydra', port_forwards=["4444", "4445"], resource_deps=["ory-hydra-migrate"])
k8s_resource(workload='rabbitmq', objects=["rabbitmq:configmap"], port_forwards=["15672"])
k8s_resource(workload='faf-user-service', objects=["faf-user-service:configmap", "faf-user-service-mail-templates"], port_forwards=["8080"], resource_deps=["ory-hydra", "faf-db"])
k8s_resource(workload='faf-api', objects=["faf-api:configmap", "faf-api-mail-templates"], port_forwards=["8010"], resource_deps=['faf-db-migrate', 'ory-hydra', 'setup-rabbitmq'])

