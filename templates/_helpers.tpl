{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cds.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "cds.ui.proxy" -}}
{{- printf "http://localhost:8001/api/v1/namespaces/%s/services/https:%s-cds-ui:https/proxy/#!/" .Release.Namespace .Release.Name -}}
{{- end -}}

{{- define "cds.api.proxy" -}}
{{- printf "http://localhost:8001/api/v1/namespaces/%s/services/https:%s-cds-api:https/proxy/#!/" .Release.Namespace .Release.Name -}}
{{- end -}}

{{- define "cds.api.service.http" -}}
{{- if eq (.Values.api.service.http.port | default .Values.commonConfig.servicePort | default 80) 80 }}
{{ printf "http://%s-api" "cds.fullname" }}
{{- else -}}
{{ printf "http://%s-api:%d" "cds.fullname" (.Values.api.service.http.port | default .Values.commonConfig.servicePort) }}
{{- end -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "cds.baselabels" }}
helm.sh/chart: {{ include "cds.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cds.api.service.grpc" -}}
{{- if eq (.Values.api.service.grpc.port | default 8082) 80 }}
{{ printf "http://%s-api" "{{ template \"cds.fullname\" . }}" }}
{{- else -}}
{{ printf "http://%s-api:%d" "{{ template \"cds.fullname\" . }}" (.Values.api.service.grpc.port | default 8082) }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cds.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cds.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cds.elasticsearch.fullname" -}}
{{- printf "%s-%s" .Release.Name "elasticsearch" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
