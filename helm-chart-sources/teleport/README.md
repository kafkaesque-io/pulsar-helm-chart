# Teleport installation

1. Clone this repo

2. Create a `pulsar` namespace in Kubernetes cluster
```
kubectl create namespace pulsar
```

2. Install Teleport

```
export TELEPORT_CHART_DIR="<repo parent dir>/pulsar-helm-chart/helm-chart-sources/teleport"
helm3 install teleport --namespace pulsar --values <value>.yaml $TELEPORT_CHART_DIR
```