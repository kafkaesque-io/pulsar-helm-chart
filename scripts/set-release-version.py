#
# This will up the releae version with patch, minor, or major version
#
# Usage: python ./set-release.version.py [major|minor|patch]
#
import yaml
import re
import sys

releaseCharts = ["pulsar", "pulsar-monitor"]
chartDir = "../helm-chart-sources/"

versionDict = {"major": 0, "minor": 1, "patch": 2} 

def help():
    print("supported args - major, minor, or patch")
    sys.exit(2)

def upversion(parts, index):
    parts[index] = str(int(parts[index]) + 1)

    if index == 0:
        parts[1] = '0'
        parts[2] = '0'
    elif index == 1:
        parts[2] = '0'
    
    return ".".join(parts)


def update(chart, version):
    print("Up chart " + chart + "'s " + version + " version")
    chartFile = chartDir + chart + "/Chart.yaml"
    with open(chartFile) as f:
        data = yaml.load(f)
        parts = re.split("\.", data["version"])

        data["version"]= upversion(parts, versionDict[version])
        print("new version " + data["version"])
        with open(chartFile, 'w') as outfile:
            yaml.dump(data, outfile, default_flow_style=False, allow_unicode=True)

if len(sys.argv) != 2:
    help()

ver = sys.argv[1]
if versionDict.get(ver) == None:
    help()

for c in releaseCharts:
    update(c, ver)
