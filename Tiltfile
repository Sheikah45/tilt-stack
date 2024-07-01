load('ext://deployment', 'job_create')

def get_pod(pod_name):
    return str(local("tilt get kd " + pod_name + " -ojsonpath='{.status.pods[0].name}'"))[1:-1]

k8s_yaml("deploy/mariadb.yaml")
k8s_yaml("deploy/ory-hydra.yaml")

local_resource(name = "setup-db", cmd = ["./scripts/setup-db.sh", get_pod("faf-db")], cmd_bat = [".\\scripts\\setup-db.bat", get_pod("faf-db")])

k8s_resource(workload='faf-db', port_forwards="3306")
k8s_resource(workload="faf-db-migrate", resource_deps=["setup-db"])
k8s_resource(workload='ory-hydra', port_forwards=["4444", "4445"], resource_deps=["ory-hydra-migrate"])