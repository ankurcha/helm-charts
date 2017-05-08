{{- define "vault_config_json" -}}
{
  "disable_mlock": false,
  "listener": {
    "tcp": {
      "address": "0.0.0.0:8200",
      "tls_cert_file": "/etc/vault/ssl/certs/vault.crt",
      "tls_key_file": "/etc/vault/ssl/certs/vault.key",
      "tls_disable": "false"
    }
  },
  "backend": {
    "consul": {
      "path": "hashicorp-vault",
      "address": "consul:8500"
    }
  }
{{- end -}}