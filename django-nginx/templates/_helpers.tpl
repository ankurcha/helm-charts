{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nginx-site-contents" -}}

server {
    listen 443 ssl default_server;

    server_name _;

    ssl on;
    ssl_certificate /etc/nginx/ssl/http-certificate.pem;
    ssl_certificate_key /etc/nginx/ssl/http-certificate-key.pem;

    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    ssl_protocols TLSv1.2;
    ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256;
    ssl_prefer_server_ciphers on;

    location ~ /ping$ {
        access_log off;
        return 200;
    }

    location / {
        proxy_pass http://127.0.0.1:{{ .Values.services.uwsgi.internalPort }};
    }

    # FIXME: workaround until cfssl > 1.2.0 released
}

server {
  listen 9145;
  allow all;
  location /metrics {
    access_log off;
    content_by_lua 'prometheus:collect()';
  }
}
{{- end -}}