[![CircleCI](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master.svg?style=svg)](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master)

# Helm Chart for an Apache Pulsar Cluster


This Helm chart configures an Apache Pulsar cluster. It includes support for:
* TLS
* Authentication
* WebSocket Proxy
* Standalone Functions Workers
* Tiered Storage
* Independent Image Versions for Components (Zookeeper, Bookkeeper, etc), enabling controlled upgrades.

## Installing and Updating
To add this chart to your local Helm repository:

```helm repo add kafkaesque https://helm.kafkaesque.io/pulsar-helm-chart```

To update to the latest chart:

```helm repo update```

Note: This command updates all your Helm charts.

To install a specific version of the chart:

```helm install --repo https://helm.kafkaesque.io pulsar-helm-chart --version v1.0.1```


Originally developed from the Helm chart from the Apache Pulsar project.
