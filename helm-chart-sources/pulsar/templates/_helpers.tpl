{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pulsar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pulsar.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pulsar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "helm-toolkit.utils.joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{- define "pulsar.zkConnectString" -}}
{{- $global := . -}}
{{- range $i, $e := until (.Values.zookeeper.replicaCount | int) -}}{{ if ne $i 0 }},{{ end }}{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}-{{ printf "%d" $i }}.{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}{{ end }}
{{- end -}}

{{- define "pulsar.bkConnectString" -}}
{{- $global := . -}}
{{- range $i, $e := until (.Values.bookkeeper.replicaCount | int) -}}{{ if ne $i 0 }},{{ end }}bk://{{ template "pulsar.fullname" $global }}-{{ $global.Values.bookkeeper.component }}-{{ printf "%d" $i }}.{{ template "pulsar.fullname" $global }}-{{ $global.Values.bookkeeper.component }}:4181{{ end }}
{{- end -}}

{{- define "pulsar.zkConnectStringOne" -}}
{{- $global := . -}}
{{- range $i, $e := until 1 -}}{{ if ne $i 0 }},{{ end }}{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}-{{ printf "%d" $i }}.{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}{{ end }}
{{- end -}}

{{- define "pulsar.bkConnectStringOne" -}}
{{- $global := . -}}
{{- range $i, $e := until 1 -}}{{ if ne $i 0 }},{{ end }}bk://{{ template "pulsar.fullname" $global }}-{{ $global.Values.bookkeeper.component }}-{{ printf "%d" $i }}.{{ template "pulsar.fullname" $global }}-{{ $global.Values.bookkeeper.component }}:4181{{ end }}
{{- end -}}

{{- define "pulsar.zkConnectStringTls" -}}
{{- $global := . -}}
{{- $port := "2281" -}}
{{- range $i, $e := until (.Values.zookeeper.replicaCount | int) -}}{{ if ne $i 0 }},{{ end }}{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}-{{ printf "%d" $i }}.{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}:{{ $port }}{{ end }}
{{- end -}}

{{- define "pulsar.zkConnectStringTlsONe" -}}
{{- $global := . -}}
{{- $port := "2281" -}}
{{- range $i, $e := until 1 -}}{{ if ne $i 0 }},{{ end }}{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}-{{ printf "%d" $i }}.{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}:{{ $port }}{{ end }}
{{- end -}}

{{- define "pulsar.zkServers" -}}
{{- $global := . }}
{{- range $i, $e := until (.Values.zookeeper.replicaCount | int) -}}{{ if ne $i 0 }},{{ end }}{{ template "pulsar.fullname" $global }}-{{ $global.Values.zookeeper.component }}-{{ printf "%d" $i }}{{ end }}
{{- end -}}
