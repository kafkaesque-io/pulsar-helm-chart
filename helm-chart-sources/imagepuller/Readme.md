## Values

| path | description |
| --- | --- |
| `image` | the image you want to pull. ex. apachepulsar/pulsar:2.4.1 |
| `pullSecret.enabled` | whether or not to use a pull secret when pulling the image |
| `pullSecret.name` | the name of the Kubernetes container registry pull secret to use when pulling the image |
| `pullSecret.key` | the key name in the Kubernetes Secret containing the registry credentials |
| `initPuller.image` | the image for the init container containing image to do pull. Default: docker |
| `initPuller.command` | the command to run in the init container, excluding image |
| `initPuller.secretMountPath` | where to mount the pull secret in the init container |
| `initPuller.secretProjection` | how to call the mounted file containint the pull secret |

## Examples

Pull a public image from Docker Hub: 
```
IMAGE=apachepulsar/pulsar-all:2.4.1
helm install imagepuller kafkaesque/imagepuller --set image=$IMAGE
```
Once all the pods are in a running state, delete the Helm release:
```
helm delete imagepuller --purge
```
