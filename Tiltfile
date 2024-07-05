config.define_string("windows-bash-path", args=False, usage="Path to bash.exe for windows")
config.define_string("test-data-path", args=False, usage="Path to test data sql file")
config.define_string_list("to-run", args=True)
cfg = config.parse()
windows_bash_path = cfg.get("windows-bash-path", "C:\\Program Files\\Git\\bin\\bash.exe")
if os.name == "nt" and not os.path.exists(windows_bash_path):
    fail("Windows users need to supply a valid path to a bash executable")
    
groups = {}
resources = []
for arg in cfg.get('to-run', []):
  if arg in groups:
    resources += groups[arg]
  else:
    # also support specifying individual services instead of groups, e.g. `tilt up a b d`
    resources.append(arg)
config.set_enabled_resources(resources)

def as_windows_command(command):
    if type(command) == 'list':
        return [windows_bash_path, "-c"] + [" ".join(command)]
    else:
        fail("Unknown command type")
    
k8s_yaml("deploy/mariadb.yaml")
k8s_yaml("deploy/rabbitmq.yaml")
k8s_yaml("deploy/ory-hydra.yaml")
k8s_yaml("deploy/faf-user-service.yaml")
k8s_yaml("deploy/faf-api.yaml")
k8s_yaml("deploy/faf-ice-breaker.yaml")
k8s_yaml("deploy/faf-lobby-server.yaml")
k8s_yaml("deploy/faf-ws-bridge.yaml")
k8s_yaml("deploy/faf-league-service.yaml")
k8s_yaml("deploy/traefik_crds.yaml")
k8s_yaml("deploy/traefik.yaml")

setup_db_command = ["scripts/setup-db.sh"]
local_resource(name = "setup-db", allow_parallel = True, cmd = setup_db_command, cmd_bat = as_windows_command(setup_db_command), resource_deps=["faf-db"], labels=["database"])
setup_rabbit_command = ["scripts/setup-rabbitmq.sh"]
local_resource(name = "setup-rabbitmq", allow_parallel = True, cmd = setup_rabbit_command, cmd_bat = as_windows_command(setup_rabbit_command), resource_deps=["rabbitmq"], labels=["messaging"])
setup_hydra_command = ["scripts/setup-hydra-clients.sh"]
local_resource(name = "setup-hydra-clients", allow_parallel = True, cmd = setup_hydra_command, cmd_bat = as_windows_command(setup_hydra_command), resource_deps=["ory-hydra"], labels=["authentication", "client"])
populate_db_command = ["scripts/populate-db.sh", cfg.get("test-data-path", "sql/test-data.sql")]
local_resource(name = "populate-db", allow_parallel = True, cmd = populate_db_command, cmd_bat = as_windows_command(populate_db_command), resource_deps=["faf-db-migrate"], labels=["database"])
populate_db_command = ["scripts/populate-coturn.sh"]
local_resource(name = "populate-coturn", allow_parallel = True, cmd = populate_db_command, cmd_bat = as_windows_command(populate_db_command), resource_deps=["faf-ice-breaker"], labels=["database"])

k8s_resource(new_name="traefik_crds", objects=["ingressroutes.traefik.io","middlewares.traefik.io","ingressroutetcps.traefik.io","ingressrouteudps.traefik.io","middlewaretcps.traefik.io","serverstransports.traefik.io","serverstransporttcps.traefik.io","tlsoptions.traefik.io","tlsstores.traefik.io","traefikservices.traefik.io"], labels=["traefik"])
k8s_resource(workload='faf-db', port_forwards="3306", labels=["database"])
k8s_resource(workload="faf-db-migrate", resource_deps=["setup-db"], labels=["database"])
k8s_resource(workload='ory-hydra-migrate', objects=["ory-hydra:configmap"], resource_deps=["faf-db"], labels=["authentication"])
k8s_resource(workload='ory-hydra', objects=["ory-hydra:ingressroute"], port_forwards=["4444","4445"], resource_deps=["ory-hydra-migrate"], labels=["authentication"])
k8s_resource(workload='rabbitmq', objects=["rabbitmq:configmap","rabbitmq:ingressroute"], port_forwards=["5672", "15672"], labels=["messaging"])
k8s_resource(workload='faf-user-service', objects=["faf-user-service:configmap", "faf-user-service-mail-templates","faf-user-service:ingressroute"], port_forwards=["8080"], resource_deps=["ory-hydra", "faf-db"], labels=["authentication", "client"])
k8s_resource(workload='faf-api', objects=["faf-api:configmap", "faf-api-mail-templates", "faf-api-api:ingressroute", "faf-api-web:ingressroute"], resource_deps=['faf-db-migrate', 'ory-hydra', 'setup-rabbitmq'], labels=["client"])
k8s_resource(workload='faf-ice-breaker', objects=["faf-ice-breaker:configmap", "faf-ice-breaker-stripprefix", "faf-ice-breaker-api:ingressroute", "faf-ice-breaker-web:ingressroute"], resource_deps=['faf-db-migrate', 'ory-hydra', 'setup-rabbitmq', 'traefik_crds'], labels=["client"])
k8s_resource(workload='faf-lobby-server', objects=["faf-lobby-server:configmap"], resource_deps=['faf-db-migrate', 'ory-hydra', 'setup-rabbitmq'], labels=["client"])
k8s_resource(workload='faf-ws-bridge', port_forwards=["8003"], resource_deps=['faf-lobby-server'], labels=["client"])
k8s_resource(workload='faf-league-service', objects=["faf-league-service:configmap"], resource_deps=['setup-db', 'setup-rabbitmq'], labels=["client"])
k8s_resource(workload='traefik-deployment', objects=["traefik-ingress-controller:clusterrole","traefik-ingress-controller:clusterrolebinding","traefik-ingress-controller:serviceaccount","traefik:ingressroute"], labels=["traefik"])