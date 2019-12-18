# Helm Chart for an Apache Pulsar Cluster [![GitHub](https://avatars1.githubusercontent.com/u/9919?s=30&v=4)](https://github.com/kafkaesque-io/pulsar-helm-chart) [![CircleCI](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master.svg?style=svg)](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master)


This Helm chart configures an Apache Pulsar cluster. It is designed for production use, but can also be used in local development environments with the proper settings.

It includes support for:
* TLS
* Authentication
* WebSocket Proxy
* Standalone Functions Workers
* Tiered Storage
* Independent Image Versions for Components (Zookeeper, Bookkeeper, etc), enabling controlled upgrades.

[Helm](https://helm.sh) 2.X must be installed and initialized to use the chart.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

_Don't want to run it yourself? Go to [Kafkaesque](https://kafkaesque.io) for fully managed Apache Pulsar services._

## Add to local Helm repository 
To add this chart to your local Helm repository:

```helm repo add kafkaesque https://helm.kafkaesque.io```

To update to the latest chart:

```helm repo update```

Note: This command updates all your Helm charts.

## Installing Pulsar in a Cloud Provider

Before you can install the chart, you need to configure the storage class depending on the cloud provider. Create a new file called ```storage_values.yaml``` and put one of these sample values:

```
# For AWS
# default_storage:
#  provisioner: kubernetes.io/aws-ebs
#  type: gp2
#  fsType: ext4
#  extraParams:
#     iopsPerGB: "10"


# For GCP
# default_storage:
#   provisioner: kubernetes.io/gce-pd
#   type: pd-ssd
#   fsType: ext4
#   extraParams:
#      replication-type: none

# For Azure
# default_storage:
#   provisioner: kubernetes.io/azure-disk
#   fsType: ext4
#   type: managed-premium
#   extraParams:
#     storageaccounttype: Premium_LRS
#     kind: Managed
#     cachingmode: ReadOnly
```


Install the chart, specifying the storage values:

```helm install --namespace pulsar --values storage_values.yaml kafkaesque/pulsar```

## Installing Pulsar for development

This chart is designed for production use. To use this chart in a development environment (ex minikube), you need to:

* Disable persistence
* Disable anti-affinity rules that ensure components run on different nodes
* Reduce resource requirements

For an example set of values, download this [values file](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/examples/dev-values.yaml). Use that values file or one like it to start the cluster:

```helm install --namespace pulsar --values dev-values.yaml```

## Accessing the Pulsar Cluster

The default values will create a ClusterIP for the proxy you can use to interact with the cluster. To find the IP address of the proxy use:

```kubectl get service```

If you want to use an external loadbalancer, here is an example set of values to use:

```
proxy:
 service:
    type: LoadBalancer
    ports:
    - name: http
      port: 8080
      nodePort: 30001
      protocol: TCP
    - name: pulsar
      port: 6650
      protocol: TCP
      nodePort: 30002
    - name: ws
      port: 8000
      protocol: TCP
      nodePort: 30003
```

## Dependencies

### Authentication
The cluster is configured to use token-based authentication. For this to work, a number of 
values need to be stored in secrets. For information on token-based
authentication in Pulsar, go [here](https://pulsar.apache.org/docs/en/security-token-admin/).

First, you need to generate a key-pair for signing the tokens using the Pulsar tokens command:

```bin/pulsar tokens create-key-pair --output-private-key my-private.key --output-public-key my-public.key```

Then you need to store those keys as secrets:

```
kubectl create secret generic token-private-key \
 --from-file=my-private.key \
 --namespace pulsar
 ```


```
kubectl create secret generic token-public-key \
 --from-file=my-public.key \
 --namespace pulsar
 ```


Using those keys, generate tokens with subjects(roles): 

```bin/pulsar tokens create --private-key file:///pulsar/token-private-key/my-private.key --subject <subject>```

You need to generate tokens with the following subjects:

- admin
- superuser
- websocket
- proxy

Once you have created those tokens, add each as a secret:

```
kubectl create secret generic token-<subject> \
 --from-file=<subject>.jwt \
 --namespace pulsar
 ```


### TLS

To use TLS, you must first create a certificate and store it in the secret defined by ```tlsSecretName```.
You can create the certificate like this:

```kubectl create secret tls <tlsSecretName> --key <keyFile> --cert <certFile>```

The resulting secret will be of type kubernetes.io/tls. The key should not be in PKCS 8 format even though that is the format used by Pulsar.  The format will be converted by chart to PKCS 8. 

You can also specify the certificate information directly in the values:

```
# secrets:
  # key: |
  # certificate: |
  # caCertificate: |
```

This is useful if you are using a self-signed certificate.

For automated handling of publicly signed certificates, you can use a tool
such as [cert-manager](https://cert-mananager).

_Originally developed from the Helm chart from the [Apache Pulsar](https://pulsar.apache.org/) project._
