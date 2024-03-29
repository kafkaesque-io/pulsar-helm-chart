[![GitHub](https://avatars1.githubusercontent.com/u/9919?s=30&v=4)](https://github.com/kafkaesque-io/pulsar-helm-chart) 
[![CircleCI](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master.svg?style=svg)](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master)
[![LICENSE](https://img.shields.io/hexpm/l/pulsar.svg)](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/LICENSE)

This chart has been deprecated and is no longer actively developed. It has been replaced by https://github.com/datastax/pulsar-helm-chart

# Helm Chart for an Apache Pulsar Cluster

This Helm chart configures an Apache Pulsar cluster. It is designed for production use, but can also be used in local development environments with the proper settings.

It includes support for:
* [TLS](#tls)
* [Authentication](#authentication)
* WebSocket Proxy
* Standalone Functions Workers
* Pulsar IO Connectors
* [Tiered Storage](#tiered-storage)
* [Pulsar SQL Workers](#pulsar-sql)
* Independent Image Versions for Components (Zookeeper, Bookkeeper, etc), enabling controlled upgrades
* [Pulsar Express Web UI](#managing-pulsar-using-pulsar-express) for managing the cluster

[Helm](https://helm.sh) must be installed and initialized to use the chart. Both Helm 2 and Helm 3 are supported.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

_Don't want to run it yourself? Go to [Kesque](https://kesque.com) for fully managed Pulsar services._

## Add to local Helm repository 
To add this chart to your local Helm repository (Helm 3):

```helm repo add kafkaesque https://helm.kafkaesque.io```

To update to the latest chart:

```helm repo update```

Note: This command updates all your Helm charts.

To list the version of the chart in the local Helm repository:

```helm search repo kafkaesque/pulsar```


## Installing Pulsar in a Cloud Provider

Before you can install the chart, you need to configure the storage class settings for your cloud provider. The handling of storage varies from cloud provider to cloud provider.

Create a new file called ```storage_values.yaml``` for the storage class settings. To use an existing storage class (including the default one) set this value:

```
default_storage:
  existingStorageClassName: default or <name of storage class>
```
For each volume of each component (Zookeeper, Bookkeeper), you can override the `default_storage` setting by specifying a different `existingStorageClassName`. This allows you to match the optimum storage type to the volume. 

If you have specific storage class requirement, for example fixed IOPS disks in AWS, you can have the chart configure the storage classes for you. Here are examples from the cloud providers:

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
See the [values file](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/helm-chart-sources/pulsar/values.yaml) for more details on these settings.

Once you have your storage settings in the values file, install the chart like this :


```helm install pulsar kafkaesque/pulsar --namespace pulsar --create-namespace --values storage_values.yaml```

## Installing Pulsar for development

This chart is designed for production use, but it can be used in development enviroments. To use this chart in a development environment (ex minikube), you need to:

* Disable anti-affinity rules that ensure components run on different nodes
* Reduce resource requirements
* Disable persistence (configuration and messages are not stored so are lost on restart). If you want persistence, you will have to configure storage settings that are compatible with your development enviroment as described above.

For an example set of values, download this [values file](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/examples/dev-values.yaml). Use that values file or one like it to start the cluster:


```helm install pulsar kafkaesque/pulsar --namespace pulsar --create-namespace --values dev-values.yaml```


## Accessing the Pulsar cluster in cloud

The default values will create a ClusterIP for all components. ClusterIPs are only accessible within the Kubernetes cluster. The easiest way to work with Pulsar is to log into the bastion host (assuming it is in the pulsar namespace):

```
kubectl exec $(kubectl get pods -l component=bastion -o jsonpath="{.items[*].metadata.name}" -n pulsar) -it -n pulsar -- /bin/bash
```
Once you are logged into the bastion, you can run Pulsar admin commands:

```
bin/pulsar-admin tenants list
```
For external access, you can use a load balancer. Here is an example set of values to use for load balancer on the proxy:

```
proxy:
 service:
    type: LoadBalancer
    ports:
    - name: http
      port: 8080
      protocol: TCP
    - name: pulsar
      port: 6650
      protocol: TCP
```

If you are using a load balancer on the proxy, you can find the IP address using:

```kubectl get service -n pulsar```

## Accessing the Pulsar cluster on localhost

To port forward the proxy admin and Pulsar ports to your local machine:

```kubectl port-forward -n pulsar $(kubectl get pods -n pulsar -l component=proxy -o jsonpath='{.items[0].metadata.name}') 8080:8080```

```kubectl port-forward -n pulsar $(kubectl get pods -n pulsar -l component=proxy -o jsonpath='{.items[0].metadata.name}') 6650:6650```

Or if you would rather go directly to the broker:

```kubectl port-forward -n pulsar $(kubectl get pods -n pulsar -l component=broker -o jsonpath='{.items[0].metadata.name}') 8080:8080```

```kubectl port-forward -n pulsar $(kubectl get pods -n pulsar -l component=broker -o jsonpath='{.items[0].metadata.name}') 6650:6650```

## Managing Pulsar using Pulsar Express

[Pulsar Express](https://github.com/bbonnin/pulsar-express) is an open-source Web UI for managing Pulsar clusters. Thanks to (Bruno Bonnin)[https://twitter.com/_bruno_b_] for creating this handy tool.

You can install Pulsar Express in your cluster by enabling with this values setting:

```
extra:
  pulsarexpress: yes
```

It will be automatically configured to connect to the Pulsar cluster.

### Accessing Pulsar Express on your local machine

To access the Pulsar Express UI on your local machine, forward port 3000:

```
kubectl port-forward -n pulsar $(kubectl get pods -n pulsar -l component=pulsarexpress -o jsonpath='{.items[0].metadata.name}') 3000:3000
```

### Accessing Pulsar Express from cloud provider

To access Pulsar Express from a cloud provider, the chart supports [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/). Your Kubernetes cluster must have a running Ingress controller (ex Nginx, Traefik, etc).

Set these values to configure the Ingress for Pulsar Express:

```
pulsarexpress:
  ingress:
    enabled: yes
    host: pulsar-ui.example.com
    annotations:
      ingress.kubernetes.io/auth-secret: ui-creds
      ingress.kubernetes.io/auth-type: basic
```
Pulsar Express does not have any built-in authentication capabilities. You should use authentication features of your Ingress to limit access. The example above (which has been tested with [Traefik](https://docs.traefik.io/)) uses annotations to enable basic authentication with the password stored in secret.

## Tiered Storage

Tiered storage (offload to blob storage) can be configured in the `storageOffload` section of the `values.yaml` file. Instructions for AWS S3 and Google Cloud Storage are provided in the file.

In addition you can configure any S3 compatible storage. There is explicit support for [Tardigrade](https://tardigrade.io), which is a provider of secure, decentralized storage. You can enable the Tardigarde S3 gateway in the `extras` configuration. The instructions for configuring the gateway are provided in the `tardigrade` section of the `values.yaml` file.

## Pulsar SQL
If you enable Pulsar SQL, the cluster provides [Presto](https://prestodb.io/) access to the data stored in BookKeeper (and tiered storage, if enabled). Presto is exposed on the service named `<release>-sql-svc`.

The easiest way to access the Presto command line is to log into the bastion host and then connect to the Presto service port, like this:

```
bin/pulsar sql --server pulsar-sql-svc:8080
```
Where the value for the `server` option should be the service name plus port. Once you are connected, you can enter Presto commands:

```
presto> SELECT * FROM system.runtime.nodes;
               node_id                |         http_uri         | node_version | coordinator | state  
--------------------------------------+--------------------------+--------------+-------------+--------
 64b7c5a1-9a72-4598-b494-b140169abc55 | http://10.244.5.164:8080 | 0.206        | true        | active 
 0a92962e-8b44-4bd2-8988-81cbde6bab5b | http://10.244.5.196:8080 | 0.206        | false       | active 
(2 rows)

Query 20200608_155725_00000_gpdae, FINISHED, 2 nodes
Splits: 17 total, 17 done (100.00%)
0:04 [2 rows, 144B] [0 rows/s, 37B/s]
```
To access Pulsar SQL from outside the cluster, you can enable the `ingress` option which will expose the Presto port on hostname. We have tested with the Traefik ingress, but any Kubernetes ingress should work. You can then run SQL queries using the Presto CLI and monitoring Presto using the built-in UI (point browser to the ingress hostname). It is recommended that you match the Presto CLI version to the version running as part of Pulsar SQL (currently 0.206).

The Presto CLI supports basic authentication, so if you enabled that on the ingress (using annotations), you can have secure Presto access.

```
presto --server https://presto.example.com --user admin --password
Password: 
presto> show catalogs;
 Catalog 
---------
 pulsar  
 system  
(2 rows)

Query 20200610_131641_00027_tzc7t, FINISHED, 1 node
Splits: 19 total, 19 done (100.00%)
0:01 [0 rows, 0B] [0 rows/s, 0B/s]
```

## Dependencies

### Authentication
The chart can enable token-based authentication for your Pulsar cluster. For information on token-based
authentication in Pulsar, go [here](https://pulsar.apache.org/docs/en/security-token-admin/).

For this to work, a number of values need to be stored in secrets prior to enabling token-based authentication. First, you need to generate a key-pair for signing the tokens using the Pulsar tokens command:

```bin/pulsar tokens create-key-pair --output-private-key my-private.key --output-public-key my-public.key```

**Note:** The names of the files used in this section match the default values in the chart. If you used different names, then you will have to update the corresponding values.

Then you need to store those keys as secrets.

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
- proxy
- websocket (only required if using the standalone WebSocket proxy)

Once you have created those tokens, add each as a secret:

```
kubectl create secret generic token-<subject> \
 --from-file=<subject>.jwt \
 --namespace pulsar
 ```

Once you have created the required secrets, you can enable token-based authentication with this setting in the values:

```
enableTokenAuth: yes
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
such as [cert-manager](https://cert-mananager). The following [page](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/aws-customer-docs.md) describes how to set up cert-manager in AWS.

Once you have created the secrets that store the cerficate info (or specified it in the values), you can enable TLS in the values:

```
enableTls: yes
```

### Chart dependency

To avoid unnecessary and frequent Prometheus chart upgrades, please pull the same chart version so that kube-prometheus-stack won't be upgraded unnecessarily.
```
helm pull prometheus-community/kube-prometheus-stack --version 12.12.2
helm dependency update
```
