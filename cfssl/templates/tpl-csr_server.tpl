{{- define "csr_server" -}}
{
    "CN": "2http.{{ .Release.Namespace }}.svc.${CLUSTER_DOMAIN}",
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "hosts": [
        "http.{{ .Release.Namespace }}.svc.${CLUSTER_DOMAIN}"
    ],
    "names": [
        {
            "C": "{{.Values.configs.cfssl.country}}",
            "L": "{{.Values.configs.cfssl.locale}}",
            "O": "{{.Values.configs.cfssl.organization}}",
            "OU": "{{.Values.configs.cfssl.organizationalunit}}",
            "ST": "{{.Values.configs.cfssl.state}}"
        }
    ]
}
{{- end -}}
