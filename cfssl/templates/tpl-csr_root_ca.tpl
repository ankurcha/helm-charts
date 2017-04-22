{{- define "csr_root_ca" -}}
{
	"CN": "{{ .Values.configs.cfssl.rootcacn }}",
	"ca": {
		"expiry": "262800h",
		"pathlen": 3
	},
	"key": {
		"algo": "ecdsa",
		"size": 256
	},
	"names": [
		{
			"C": "{{ .Values.configs.cfssl.country }}",
			"L": "{{ .Values.configs.cfssl.locale }}",
			"O": "{{ .Values.configs.cfssl.organization }}",
			"OU": "{{ .Values.configs.cfssl.caname }}",
			"ST": "{{ .Values.configs.cfssl.state }}"
		}
	]
}
{{- end -}}
