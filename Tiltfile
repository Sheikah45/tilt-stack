config.define_string("windows-bash-path", args=False, usage="Path to bash.exe for windows")
config.define_string("test-data-path", args=False, usage="Path to test data sql file")
config.define_string("lobby-server-path", args=False, usage="Path to lobby server repository")
config.define_string_list("to-run", args=True)
cfg = config.parse()
windows_bash_path = cfg.get("windows-bash-path", "C:\\Program Files\\Git\\bin\\bash.exe")
data_relative_path = "data"
if os.name == "nt":
    drive, path_without_drive = os.getcwd().split(":")
    if k8s_context() != "docker-desktop":
        fail("Cannot determine data path for non docker desktop on windows")
    data_absolute_path = os.path.join("/run/desktop/mnt/host/", drive, path_without_drive, data_relative_path).replace("\\","/").lower()
    if not os.path.exists(windows_bash_path):
        fail("Windows users need to supply a valid path to a bash executable")
else:
    data_absolute_path = os.path.join(os.getcwd(), data_relative_path)

def as_windows_command(command):
    if type(command) == "list":
        return [windows_bash_path, "-c"] + [" ".join(command)]
    else:
        fail("Unknown command type")

def remove_objects_of_kind(yaml, kinds):
    objects = decode_yaml_stream(yaml)
    return encode_yaml_stream([object for object in objects if object["kind"] not in kinds])

def keep_objects_of_kind(yaml, kinds):
    objects = decode_yaml_stream(yaml)
    return encode_yaml_stream([object for object in objects if object["kind"] in kinds])

def cronjob_to_job(yaml):
    objects = decode_yaml_stream(yaml)
    for object in objects:
        if object["kind"] == "CronJob":
            object["kind"] = "Job"
            spec = object["spec"]
            spec.pop("suspend")
            spec.pop("schedule")
            jobTemplate = spec.pop("jobTemplate")
            spec["template"] = jobTemplate["spec"]["template"]

    return encode_yaml_stream(objects)

def to_hostpath_storage(yaml):
    objects = decode_yaml_stream(yaml)
    for object in objects:
        if object["kind"] == "PersistentVolume":
            object["spec"].pop("nodeAffinity")
            localpath = object["spec"].pop("local")
            object["spec"]["hostPath"] = localpath
            object["spec"]["hostPath"]["type"] = "DirectoryOrCreate"
            object["spec"]["accessModes"] = ["ReadWriteMany"]
        if object["kind"] == "PersistentVolumeClaim":
            object["spec"]["accessModes"] = ["ReadWriteMany"]
            
    return encode_yaml_stream(objects)

watch_file("config/values-local.yaml")

load("ext://git_resource", "git_checkout")

if not os.path.exists("gitops-stack"):
    git_checkout("git@github.com:FAForever/gitops-stack.git", "gitops-stack")

k8s_yaml("config/namespaces.yaml")
k8s_resource(new_name="namespaces", objects=["faf-infra:namespace", "faf-apps:namespace", "faf-ops:namespace"], labels=["core"])

k8s_yaml(to_hostpath_storage(helm("gitops-stack/cluster/storage", values=["config/values-local.yaml"], set=["dataPath="+data_absolute_path])))

k8s_yaml("local-secrets/postgres.yaml")
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/infra/postgres", namespace="faf-infra", values=["config/values-local.yaml"]), kinds=["InfisicalSecret"]))
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/apps/faf-postgres", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["InfisicalSecret"]))
k8s_resource(new_name="postgres-volume", objects=["postgres:persistentvolume", "postgres-pvc:persistentvolumeclaim"], resource_deps=["namespaces"], labels=["database"])
k8s_resource(workload="postgres", objects=["postgres:configmap", "postgres:secret", "postgres:service:faf-apps"], port_forwards=["5432"], resource_deps=["postgres-volume"], labels=["database"])

k8s_yaml("local-secrets/mariadb.yaml")
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/infra/mariadb", namespace="faf-infra", values=["config/values-local.yaml"]), kinds=["InfisicalSecret"]))
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/apps/faf-mariadb", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["InfisicalSecret"]))
k8s_resource(new_name="mariadb-volume", objects=["mariadb:persistentvolume", "mariadb-pvc:persistentvolumeclaim"], resource_deps=["namespaces"], labels=["database"])
k8s_resource(workload="mariadb", objects=["mariadb:configmap", "mariadb:secret", "mariadb:service:faf-apps"], port_forwards=["3306"], resource_deps=["mariadb-volume"], labels=["database"])

k8s_yaml("local-secrets/rabbitmq.yaml")
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/apps/rabbitmq", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["InfisicalSecret"]))
k8s_resource(new_name="rabbitmq-volume", objects=["rabbitmq:persistentvolume", "rabbitmq-pvc:persistentvolumeclaim"], resource_deps=["namespaces"], labels=["database"])
k8s_resource(workload="rabbitmq", objects=["rabbitmq:configmap", "rabbitmq:secret"], port_forwards=["15672"], resource_deps=["rabbitmq-volume"], labels=["database"])

k8s_yaml("local-secrets/faf-db-migrations.yaml")
k8s_yaml(cronjob_to_job(remove_objects_of_kind(helm("gitops-stack/apps/faf-db-migrations", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["InfisicalSecret"])))
k8s_resource(workload="faf-db-migrations", objects=["faf-db-migrations:secret"], resource_deps=["setup-mariadb"], labels=["database"])

k8s_yaml("local-secrets/faf-voting.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-voting", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-voting-config", objects=["faf-voting:configmap", "faf-voting:secret"], labels=["voting"])

k8s_yaml("local-secrets/faf-website.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-website", namespace="faf-apps", values=["config/values-local.yaml", "gitops-stack/apps/faf-website/values-prod.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-website-config", objects=["faf-website:configmap", "faf-website:secret"], labels=["website"])

k8s_yaml("local-secrets/nodebb.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/nodebb", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="nodebb-config", objects=["nodebb:configmap", "nodebb:secret"], labels=["forum"])

k8s_yaml("local-secrets/ergochat.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/ergochat", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="ergochat-config", objects=["ergochat:configmap", "ergochat:secret"], labels=["chat"])

k8s_yaml("local-secrets/faf-api.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-api", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-api-config", objects=["faf-api:configmap", "faf-api:secret"], labels=["api"])

k8s_yaml("local-secrets/faf-league-service.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-league-service", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-league-service-config", objects=["faf-league-service:configmap", "faf-league-service:secret"], labels=["leagues"])

k8s_yaml("local-secrets/faf-lobby-server.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-lobby-server", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-lobby-server-config", objects=["faf-lobby-server:configmap", "faf-lobby-server:secret"], labels=["lobby"])

k8s_yaml("local-secrets/faf-policy-server.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-policy-server", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-policy-server-config", objects=["faf-policy-server:configmap", "faf-policy-server:secret"], labels=["lobby"])

k8s_yaml("local-secrets/faf-replay-server.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-replay-server", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-replay-server-config", objects=["faf-replay-server:configmap", "faf-replay-server:secret"], labels=["replay"])

k8s_yaml("local-secrets/faf-user-service.yaml")
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/apps/faf-user-service", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["InfisicalSecret", "IngressRoute"]))
k8s_resource(new_name="faf-user-service-config", objects=["faf-user-service:configmap", "faf-user-service:secret"], labels=["user"])
k8s_resource(workload="faf-user-service", port_forwards=["8080"], labels=["user"])

k8s_yaml("local-secrets/wordpress.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/wordpress", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="wordpress-config", objects=["wordpress:configmap", "wordpress:secret"], labels=["website"])

k8s_yaml("local-secrets/wikijs.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/wikijs", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="wikijs-config", objects=["wikijs:configmap", "wikijs:secret"], labels=["wiki"])

k8s_yaml("local-secrets/debezium.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/debezium", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="debezium-config", objects=["debezium:configmap", "debezium:secret"], labels=["database"])

k8s_yaml("local-secrets/faf-icebreaker.yaml")
k8s_yaml(keep_objects_of_kind(helm("gitops-stack/apps/faf-icebreaker", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["ConfigMap"]))
k8s_resource(new_name="faf-icebreaker-config", objects=["faf-icebreaker:configmap", "faf-icebreaker:secret"], labels=["user"])

k8s_yaml("local-secrets/ory-hydra.yaml")
k8s_yaml(remove_objects_of_kind(helm("gitops-stack/apps/ory-hydra", namespace="faf-apps", values=["config/values-local.yaml"]), kinds=["InfisicalSecret", "IngressRoute", "CronJob"]))
k8s_resource(new_name="ory-hydra-config", objects=["ory-hydra:configmap", "ory-hydra:secret"], labels=["ory-hydra"])
k8s_resource(workload="ory-hydra-migration", resource_deps=["ory-hydra-config", "setup-postgres"], labels=["ory-hydra"])
k8s_resource(workload="ory-hydra", resource_deps=["ory-hydra-migration"], port_forwards=["4444", "4445"], labels=["ory-hydra"])
for i in range(1, 10):
    k8s_resource(workload="ory-hydra-create-client-"+str(i), resource_deps=["ory-hydra"], labels=["ory-hydra"])

setup_postgres_command = ["./init-postgres.sh"]
local_resource(name = "setup-postgres", dir="gitops-stack/scripts/", allow_parallel = True, cmd = setup_postgres_command, cmd_bat = as_windows_command(setup_postgres_command), resource_deps=["postgres", "wikijs-config", "ory-hydra-config"], labels=["database"])

setup_mariadb_command = ["./init-mariadb.sh"]
local_resource(name = "setup-mariadb", dir="gitops-stack/scripts/", allow_parallel = True, cmd = setup_mariadb_command, cmd_bat = as_windows_command(setup_mariadb_command), resource_deps=["mariadb", "faf-api-config", "faf-user-service-config", "faf-lobby-server-config", "faf-replay-server-config", "faf-policy-server-config", "faf-league-service-config", "wordpress-config", "ergochat-config"], labels=["database"])

setup_rabbitmq_command = ["./init-rabbitmq.sh"]
local_resource(name = "setup-rabbitmq", dir="gitops-stack/scripts/", allow_parallel = True, cmd = setup_rabbitmq_command, cmd_bat = as_windows_command(setup_rabbitmq_command), resource_deps=["rabbitmq", "faf-api-config", "faf-icebreaker-config", "faf-lobby-server-config", "debezium-config", "faf-api-config", "faf-league-service-config", "wordpress-config", "ergochat-config"], labels=["database"])