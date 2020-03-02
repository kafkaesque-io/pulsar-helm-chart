#!/bin/bash

#
# this script detects the HEAD has updated the specified git files.
# return 0 if the watch list have been updated.
# 

# dir where this script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# latest commit HEAD
HEAD=$(git rev-parse HEAD)

watchFiles=("helm-chart-sources/pulsar/Chart.yaml" "helm-chart-sources/imagepuller/Chart.yaml" "helm-chart-sources/teleport/Chart.yaml" "helm-chart-sources/pulsar-monitor/Chart.yaml")

releaseRequired=0
echo HEAD is ${HEAD}

# build a list of latest commits on these watch files
for ele in "${watchFiles[@]}"; do
    commit=$(git log -1 --format=format:%H --full-diff ${DIR}/../${ele})
    echo ${ele} ${commit}
    if [ $HEAD = $commit ]; then
      echo "this commit ${HEAD} updated ${ele} that requires to build chart"
      releaseRequired=1 
    fi
done

if [ $releaseRequired -ne 0 ]; then
    ${DIR}/install_tools.sh
    ${DIR}/release.sh
else
    echo "release is not required"
fi
