k8s_yaml("deploy/mariadb.yaml")
k8s_yaml("deploy/ory-hydra.yaml")
k8s_yaml("deploy/faf-user-service.yaml")

k8s_resource(workload='faf-db', port_forwards="3306")
local_resource(name = "setup-db", cmd = [os.path.abspath("scripts/setup-db.sh")], cmd_bat = [os.path.abspath("scripts/setup-db.bat")], resource_deps=["faf-db"])
k8s_resource(workload="faf-db-migrate", resource_deps=["setup-db"])
k8s_resource(workload='ory-hydra-migrate', objects=["ory-hydra:configmap"], resource_deps=["faf-db"])
k8s_resource(workload='ory-hydra', port_forwards=["4444", "4445"], resource_deps=["ory-hydra-migrate"])
local_resource(name = "setup-hydra-clients", cmd = [os.path.abspath("scripts/setup-hydra-clients.sh")], cmd_bat = [os.path.abspath("scripts/setup-hydra-clients.bat")], resource_deps=["ory-hydra"])
k8s_resource(workload='faf-user-service', objects=["faf-user-service:configmap", "faf-user-service-mail-templates"], port_forwards=["8080"], resource_deps=["ory-hydra", "faf-db"])

