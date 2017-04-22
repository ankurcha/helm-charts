{{- define "csr_intermediate_ca" -}}
{
	"CN": "{{ .Values.configs.cfssl.intermediatecacn }}",
	"ca": {
		"expiry": "42720h",
		"pathlen": 2
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
			"OU": "{{ .Values.configs.cfssl.initcaname }}",
			"ST": "{{ .Values.configs.cfssl.state }}"
		}
	]
}
{{- end -}}
