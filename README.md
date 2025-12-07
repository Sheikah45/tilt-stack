# Tilt Stack
This repository aims to provide a ready-to-go [Tilt](https://docs.tilt.dev/) setup for ephemeral FAF infrastructure local development on kubernetes.

## Structure
The tilt stack uses kubernetes resources from the [gitops-stack](https://github.com/FAForever/gitops-stack). The inifisical secrets manager is
replaced by local secrets iin the local-secrets folder. The traefik ingress controller is also currently removed

## Configuration
The tilt stack is designed to replicate production as close as possible for local development. The default values from gitops-stack have been =
used where applicable

## Data
The tilt stack is currently intended to be used transiently so there is no local storage. All the data and resources are created and destroyed with their containers.

# Usage
## Prerequisites
* [Tilt](https://docs.tilt.dev/install.html)
* Kuberenetes ([Minikube](https://minikube.sigs.k8s.io/docs/) or [Docker Desktop](https://docs.docker.com/desktop/kubernetes/) is recommended for those new to kubernetes) (Tilt cluster setup)[https://docs.tilt.dev/choosing_clusters]
* For windows users a bash program. By default git bash is used with an assumed installation directory of C:/Program Files/Git
* [jq](https://jqlang.org/) must be installed for some of the setup scripts to work

## Startup Services
In the root directoy of your repository run `tilt up`. This will start all the faf services in the correct order. The status of each service can be viewed in the tilt UI by visiting http://localhost:10350. This is the control server for tilt where you can restart services or disable them for substitution by services you would like to run from source code as you actively develop them.

## Development
To develop against the FAF infrastructure you should disable the service in tilt that you are actively developing. Once disabled you can start up your developed version. Some tweaks may need to be made to the default configuration parameters in the source code. The proper values can be found in the configMaps in each of the services kubernetes deploy yaml files.

## Test Data
The default test data that is loaded can be found in /sql/test-data.sql. This can be overridden by providing a new path with the tilt configuration key test-data-path when running tilt up or in the tilt_config.json file in the repository root directory.
