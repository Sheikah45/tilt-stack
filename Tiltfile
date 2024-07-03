config.define_string("windows-bash-path", args=False, usage="Path to bash.exe for windows")
config.define_string("test-data-path", args=False, usage="Path to test data sql file")
config.define_string_list("to-run", args=True)
cfg = config.parse()
groups = {}
resources = []
for arg in cfg.get('to-run', []):
  if arg in groups:
    resources += groups[arg]
  else:
    # also support specifying individual services instead of groups, e.g. `tilt up a b d`
    resources.append(arg)
config.set_enabled_resources(resources)

print(os.name)

def as_windows_command(command):
    if type(command) == 'list':
        return [cfg.get("windows-bash-path", "C:\\Program Files\\Git\\bin\\bash.exe"), "-c"] + [" ".join(command)]
    else:
        fail("Unknown command type")
    
k8s_yaml("deploy/mariadb.yaml")
k8s_yaml("deploy/rabbitmq.yaml")
k8s_yaml("deploy/ory-hydra.yaml")
k8s_yaml("deploy/faf-user-service.yaml")
k8s_yaml("deploy/faf-api.yaml")
k8s_yaml("deploy/faf-lobby-server.yaml")
k8s_yaml("deploy/faf-ws-bridge.yaml")

setup_db_command = ["scripts/setup-db.sh"]
local_resource(name = "setup-db", allow_parallel = True, cmd = setup_db_command, cmd_bat = as_windows_command(setup_db_command), resource_deps=["faf-db"], labels=["database"])
setup_rabbit_command = ["scripts/setup-rabbitmq.sh"]
local_resource(name = "setup-rabbitmq", allow_parallel = True, cmd = setup_rabbit_command, cmd_bat = as_windows_command(setup_rabbit_command), resource_deps=["rabbitmq"], labels=["messaging"])
setup_hydra_command = ["scripts/setup-hydra-clients.sh"]
local_resource(name = "setup-hydra-clients", allow_parallel = True, cmd = setup_hydra_command, cmd_bat = as_windows_command(setup_hydra_command), resource_deps=["ory-hydra"], labels=["authentication", "client"])
populate_db_command = ["scripts/populate-db.sh", cfg.get("test-data-path", "sql/test-data.sql")]
local_resource(name = "populate-db", allow_parallel = True, cmd = populate_db_command, cmd_bat = as_windows_command(populate_db_command), resource_deps=["faf-db-migrate"], labels=["database"])

k8s_resource(workload='faf-db', port_forwards="3306", labels=["database"])
k8s_resource(workload="faf-db-migrate", resource_deps=["setup-db"], labels=["database"])
k8s_resource(workload='ory-hydra-migrate', objects=["ory-hydra:configmap"], resource_deps=["faf-db"], labels=["authentication"])
k8s_resource(workload='ory-hydra', port_forwards=["4444", "4445"], resource_deps=["ory-hydra-migrate"], labels=["authentication"])
k8s_resource(workload='rabbitmq', objects=["rabbitmq:configmap"], port_forwards=["15672"], labels=["messaging"])
k8s_resource(workload='faf-user-service', objects=["faf-user-service:configmap", "faf-user-service-mail-templates"], port_forwards=["8080"], resource_deps=["ory-hydra", "faf-db"], labels=["authentication", "client"])
k8s_resource(workload='faf-api', objects=["faf-api:configmap", "faf-api-mail-templates"], port_forwards=["8010"], resource_deps=['faf-db-migrate', 'ory-hydra', 'setup-rabbitmq'], labels=["client"])
k8s_resource(workload='faf-lobby-server', objects=["faf-lobby-server:configmap"], resource_deps=['faf-db-migrate', 'ory-hydra', 'setup-rabbitmq'], labels=["client"])
k8s_resource(workload='faf-ws-bridge', port_forwards=["8003"], resource_deps=['faf-lobby-server'], labels=["client"])

