{{- define "csr_server" -}}
{
    "CN": "{{.Values.configs.cfssl.httpcnprefix}}.{{.Values.kubecontext}}.local",
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
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
