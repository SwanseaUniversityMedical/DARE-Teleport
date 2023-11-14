{{/*
Helper template which constructs the namespace for a given component.
Concatenating the global.namespacePrefix and the app's namespace value,
truncating the result and ensuring leading and trailing hyphens are trimmed.
EXAMPLE USAGE: {{- include "teleport.namespace" (dict "Values" .Values "namespace" .Values.appTrino.namespace) -}}
*/}}
{{- define "teleport.namespace"  -}}
{{- (printf "%s-%s" (default "" .Values.global.namespacePrefix | trunc 63 | trimAll "-") (default "" .namespace | trunc 63 | trimAll "-")) | trunc 63 | trimAll "-" -}}
{{- end -}}
