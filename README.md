[![CircleCI](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master.svg?style=svg)](https://circleci.com/gh/kafkaesque-io/pulsar-helm-chart/tree/master)

# Helm Chart for an Apache Pulsar Cluster


This Helm chart configures an Apache Pulsar cluster. It includes support for:
* TLS
* Authentication
* WebSocket Proxy
* Standalone Functions Workers
* Tiered Storage
* Independent Image Versions for Components (Zookeeper, Bookkeeper, etc), enabling controlled upgrades.

## Add to local Helm repository 
To add this chart to your local Helm repository:

```helm repo add kafkaesque https://helm.kafkaesque.io```

To update to the latest chart:

```helm repo update```

Note: This command updates all your Helm charts.

## Installing Pulsar

Once you have added the repository, install the chart:

```helm install kafkaesque/pulsar```

To install a specific version of the chart:

```helm install --repo https://helm.kafkaesque.io pulsar --version v1.0.1```

## Dependencies

### Authentication
The cluster is configured to use token-based authentication. For this to work, a number of 
values need to be stored in secrets. For information on token-based
authentication in Pulsar, go [here](https://pulsar.apache.org/docs/en/security-token-admin/).

First, you need to generate a key-pair for signing the tokens using the Pulsar tokens command:

```bin/pulsar tokens create-key-pair --output-private-key my-private.key --output-public-key my-public.key```

Then you need to store those keys as secrets:

```kubectl create secret generic token-private-key \
 --from-file=my-private.key \
 --namespace pulsar```


```kubectl create secret generic token-public-key \
 --from-file=my-public.key \
 --namespace pulsar```


Using those keys, generate tokens with subjects(roles): 

```bin/pulsar tokens create --private-key file:///pulsar/token-private-key/my-private.key --subject <subject>```

You need to generate tokens with the following subjects:

- admin
- superuser
- websocket
- proxy

Once you have created those tokens, add each as a secret:

```kubectl create secret generic token-<subject> \
 --from-file=<subject>.jwt \
 --namespace pulsar```


### TLS

To use TLS, you must first create a certificate and store it in the secret defined by ```tlsSecretName```.
You can create the certificate like this:

```kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}```

The resulting secret will be of type kubernetes.io/tls. For automated handling of certificates,

_Originally developed from the Helm chart from the Apache Pulsar project._
