# Installing Teleport for Kesque
Here are the steps to install Teleport to grant remote access to the Kesque team.

Make sure Helm is installed and can access your Kubernetes cluster.

Note: The Helm repo uses our old name, Kafkaesque.

## Add the Kafkaesque Helm repo.

```
helm repo add kafkaesque https://helm.kafkaesque.io
```

Install the chart using the provided YAML file. The namespace doesn't matter. We just use 'pulsar' by convention, but you can use a different namespace if you want.

```
(helm 2)
helm install --name teleport --namespace pulsar --values <file>.yaml kafkaesque/teleport

(helm 3)
kubectl create namespace pulsar
helm install teleport kafkaesque/teleport --values <file>.yaml kafkaesque/teleport
```

Make sure the Teleport pod goes into the running state.

Let's us know that Teleport is running so we can confirm that we can properly remotely access the cluster.
