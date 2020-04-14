Kafkaesque Helm Chart Releases
====================================================

# Chart Releaser

 The [chart-releaser](https://github.com/helm/chart-releaser) is being used to enable the pulsar-helm-chart [repo](https://github.com/kafkaesque-io/pulsar-helm-chart) to self-host Helm Chart releases via the use of Github pages.

# CircleCI

CircleCI is being used to release a new version of the Kafkaesque Pulsar Helm Charts. The [release script](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/master/.circleci/release.sh) creates a release package of the new Helm Chart version and updates the [index.yaml](https://github.com/kafkaesque-io/pulsar-helm-chart/blob/gh-pages/index.yaml) which in this case is hosted in a Github page. The CircleCI is triggered, when a new commit is pushed in the **master** branch.

# How to Release a new Version

## How to trigger a release build

A release is built by pushing a commit with a new version to a release branch, or a release tag to remote. Usually, Chart.yaml files are required to be up versioned in a commit for this purpose.  

## Up version charts

Since there could be multiple helm charts, we provide a script to update all required charts automatically. It can automatically upversion based on major, minor, or patch release. The script only updates the `version` under Chart.yaml if the local subfolder of `./helm-chart-sources` differs from `origin master`.

``` bash
$ cd ./scripts
$ python set-release-version.py patch
```

A release branch's name or a release tag must conform this regex `release[0-9].*`. This will simplify the workflow. Circl CI release build will be automatically triggered based on a remote release branch or tag is pushed.

For a new Helm Chart release the version of the Helm Chart should be updated in the *Chart.yaml*. The chart-releaser tool will handle the packaging of the new version, will push it to the Github repo as a new [release](https://github.com/kafkaesque-io/pulsar-helm-chart/releases) and update the index file to reflect the new version.

# How to Install a New Release

The *index.yaml* is hosted in a Github page and can be accessed via https://helm.kafkaesque.io/. In order to make use of a Kafkaesque Pulsar Helm Chart specific version the Kafkaesque Helm repo should be added first by running:

```bash
helm repo add kafkaesque https://helm.kafkaesque.com
```

And then a version of the preferred chart can be installed by running:

```bash
helm install --namespace pulsar --repo https://helm.kafkaesque.io <chart_name> --version <version_number>
```

For example:


```bash
helm install --namespace pulsar --repo https://helm.kafkaesque.io pulsar --version v1.0.3
```

If no Helm Chart version is specified the latest version will be installed.
