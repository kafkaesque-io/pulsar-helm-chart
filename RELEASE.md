Kafkaesque Helm Chart Releases
====================================================

# Chart Releaser

 The [chart-releaser](https://github.com/helm/chart-releaser) is being used to enable the pulsar-helm-chart [repo](https://github.com/kafkaesque-io/pulsar-helm-chart) to self-host Helm Chart releases via the use of Github pages.

# CircleCI

CircleCI is being used to release a new version of the Kafkaesque Pulsar Helm Charts. The [release script](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/.circleci/release.sh) creates a release package of the new Helm Chart version and updates the [index.yaml](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/gh-pages/index.yaml) which in this case is hosted in a Github page. The CircleCI is triggered, when a new commit is pushed in the **release** branch.

# How to Release a new Version

The release process is automated using CircleCI. It uses the [chart-releaser](https://github.com/helm/chart-releaser) tool.

For a new Helm Chart release the version of the Helm Chart should be updated in the *Chart.yaml*. Do this for each chart that has changed and commit to **master**. This is important. If you don't change the version and the chart has changed, the downstream release process will fail.

To trigger a release:
```
git fetch
git checkout release
git rebase origin/master
git push origin release
```

The chart-releaser tool will handle the packaging of the new version, will push it to the Github repo as a new [release](https://github.com/kafkaesque-io/pulsar-helm-chart/releases). It will update the index.yaml file for the Helm repo and commit it to **master** since this is where the GitHub pages are hosted. 

You should verify that the new chart version are present in the index.yaml:

https://helm.kafkaesque.io/index.yaml


# How to Install a New Release

The *index.yaml* is hosted in a Github page and can be accessed via https://helm.kafkaesque.io/. In order to make use of a Kafkaesque Pulsar Helm Chart specific version the Kafkaesque Helm repo should be added first by running:

```bash
helm repo add kafkaesque https://helm.kafkaesque.com
```

And then a version of the preferred chart can be installed by running:

```bash
helm install --namespace pulsar kafkaesque/pulsar --version <version_number>
```
Or for Helm3:

```
helm3 install <name> --namespace pulsar --version <version_number> kafkaesque/pulsar
```

For example:


```bash
helm install --namespace pulsar --repo https://helm.kafkaesque.io pulsar --version v1.0.3
```

If no Helm Chart version is specified the latest version will be installed.
