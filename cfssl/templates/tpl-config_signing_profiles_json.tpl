{{- define "config_signing_profiles_json" -}}
{
    "signing": {
        "default": {
            "expiry": "87600h"
        },
        "profiles": {
            "server": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "43800h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            "int": {
                "expiry": "175200h",
                "is_ca": true,
                "ca_constraint": {
                    "is_ca": true,
                    "max_path_len": 2,
                    "max_path_len_zero": false
                },
                "usages": [
                    "digital signature",
                    "cert sign",
                    "crl sign",
                    "signing"
                ]
            }
        }
    }
}
{{- end -}}
