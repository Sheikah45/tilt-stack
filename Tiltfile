load('ext://git_resource', 'git_checkout', 'deploy_from_dir')

def get_pod(pod_name):
    return str(local("tilt get kd " + pod_name + " -ojsonpath='{.status.pods[0].name}'"))[1:-1]

k8s_yaml("deploy/mariadb.yaml")
k8s_yaml("deploy/ory-hydra.yaml")
k8s_yaml("deploy/faf-user-service.yaml")

local_resource(name = "setup-db", cmd = [os.path.abspath("scripts/setup-db.sh"), get_pod("faf-db")], cmd_bat = [os.path.abspath("scripts/setup-db.bat"), get_pod("faf-db")])
local_resource(name = "setup-hydra-clients", cmd = [os.path.abspath("scripts/setup-hydra-clients.sh"), get_pod("ory-hydra")], cmd_bat = [os.path.abspath("scripts/setup-hydra-clients.bat"), get_pod("ory-hydra")], resource_deps=["ory-hydra"])

k8s_resource(workload='faf-db', port_forwards="3306")
k8s_resource(workload="faf-db-migrate", resource_deps=["setup-db"])
k8s_resource(workload='ory-hydra-migrate', resource_deps=["faf-db"])
k8s_resource(workload='ory-hydra', objects=["ory-hydra:configmap"], port_forwards=["4444", "4445"], resource_deps=["ory-hydra-migrate"])
k8s_resource(workload='faf-user-service', objects=["faf-user-service:configmap", "faf-user-service-mail-templates"], port_forwards=["8080"], resource_deps=["ory-hydra", "faf-db"])