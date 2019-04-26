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

{{/* Generate basic labels */}}
{{- define "cds.baselabels.test" }}
{{- $global := . -}}
{{- range $key, $val := .Global.Values.commonLabels }}
{{- $key }}: {{ tpl $val $global }}
{{ end -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "cds.baselabels" }}
{{- $global := . -}}
{{- range $key, $val := .Values.commonLabels }}
{{- $key }}: {{ tpl $val $global }}
{{ end -}}
{{- end -}}

{{/* Create the URL for the CDS UI when there is no Ingress */}}
{{- define "cds.ui.proxy" -}}
{{- printf "http://localhost:8001/api/v1/namespaces/%s/services/https:%s-cds-ui:https/proxy/#!/" .Release.Namespace .Release.Name -}}
{{- end -}}

{{/* Create the URL for the CDS API when there is no Ingress */}}
{{- define "cds.api.proxy" -}}
{{- printf "http://localhost:8001/api/v1/namespaces/%s/services/https:%s-cds-api:https/proxy/#!/" .Release.Namespace .Release.Name -}}
{{- end -}}

{{/* Generate the API GRPC service endpoint information */}}
{{- define "cds.api.service.grpc" -}}
{{ $port := .Values.api.service.grpc.port | default 8082 | int }}
{{- if eq $port 80 -}}
http://{{ template "cds.fullname" . }}-api
{{- else -}}
http://{{ template "cds.fullname" . }}-api:{{ $port }}
{{- end -}}
{{- end -}}

{{/* Generate the API HTTP service endpoint information */}}
{{- define "cds.api.service.http" -}}
{{ $port := .Values.api.service.http.port | default .Values.commonConfig.servicePort | default 80 | int }}
{{- if eq $port 80 -}}
http://{{ template "cds.fullname" . }}-api
{{- else -}}
http://{{ template "cds.fullname" . }}-api:{{ $port | toString }}
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

{{/*
Create the name of the service account to use
*/}}
{{- define "cds.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "cds.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
