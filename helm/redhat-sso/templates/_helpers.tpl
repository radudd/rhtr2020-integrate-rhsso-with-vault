{{- define "sso.fullname" -}}
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
{{- define "sso.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "sso.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sso.affinity" -}}
  {{- if  .Values.affinity }}
      affinity:
        {{ tpl .Values.affinity . | nindent 8 | trim }}
  {{ end }}
{{- end -}}

{{- define "sso.nodeselector" -}}
  {{- if  .Values.nodeSelector }}
      nodeSelector:
        {{ tpl .Values.nodeSelector . | indent 8 | trim }}
  {{- end }}
{{- end -}}

{{- define "sso.annotations" -}}
  {{- if .Values.annotations }}
        {{- $tp := typeOf .Values.annotations }}
        {{- if eq $tp "string" }}
          {{- tpl .Values.annotations . | nindent 8 }}
        {{- else }}
          {{- toYaml .Values.annotations | nindent 8 }}
        {{- end }}
  {{- end }}
{{- end -}}

{{- define "sso.tolerations" -}}
  {{- if  .Values.tolerations }}
      tolerations:
        {{ tpl .Values.tolerations . | nindent 8 | trim }}
  {{- end }}
{{- end -}}