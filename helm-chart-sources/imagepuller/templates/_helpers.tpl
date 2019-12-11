{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "imagepuller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "imagepuller.fullname" -}}
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
{{- define "imagepuller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "imagepuller.labels" -}}
app.kubernetes.io/name: {{ include "imagepuller.name" . }}
helm.sh/chart: {{ include "imagepuller.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Detect the latest api version of Daemonset supported by the cluster
*/}}
{{- define "imagepuller.detectdsversion" -}}
{{ $res := "" }}
{{- if $.Capabilities.APIVersions.Has "extensions/v1beta1" -}}
{{- $res = "extensions/v1beta1" -}}
{{- end -}}
{{- if $.Capabilities.APIVersions.Has "apps/v1beta2" -}}
{{- $res = "apps/v1beta2" -}}
{{- end -}}
{{- if $.Capabilities.APIVersions.Has "apps/v1" -}}
{{- $res = "apps/v1" -}}
{{- end -}}
{{- $res -}}
{{- end -}}