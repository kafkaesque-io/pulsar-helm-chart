# Helm Chart for an Apache Pulsar Cluster

This Helm chart configures an Apache Pulsar cluster. It includes support for:
* TLS
* Authentication
* WebSocket Proxy
* Standalone Functions Workers
* Tiered Storage
* Independent Image Versions for Components (Zookeeper, Bookkeeper, etc), enabling controlled upgrades.

To add this chart to your local Helm repository:

```helm repo add kafkaesquehelm https://kafkaesque-io.github.io/pulsar-helm-chart```

Originally developed from the Helm chart from the Apache Pulsar project.
