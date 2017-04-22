# cfssl Helm Chart
Deploys cfssl CA service to https://cfssl.kube-system.svc.$(cluster).local

NEEDS:
 health check
## Components

### Pod mounts
- migrate-job
  /goose-config/init-template/
  /goose-config/migrations/001_CreateCertificates.sql
  /goose-init-template/

- http (cfssl container)
  - init-setup (sign initial certs)
    /configs # pki parameters
    /etc/bootstrap/
    /initial-certificate-store/ (PVC)

### Services
- http
# Secrets
The following secrets should be set in landscaper:
- POSTGRESUSER
- POSTGRESPASSWORD

cfssl is loaded with a CA, used by pods to dynamically generate their certificates (typically via an init container and shared volume):

TODO: document init-container client cert generation / placement

it's used for node sidecars to write tls secrets

- read auth token from
- make a request to cfssl.kube-system.svc

TODO: service that writes to a configmap for auth token (via k8s serviceaccount?) generation

```
`cfssl gencert -remote=10.97.134.97:8888 -profile=client -config config_client.json csr_client.json`

# Walk-through
- Generate CA (Helm template)
```root_cert_json.tpl
{
        "CN": "{{ .Values.configs.cfssl.rootcacn }}",
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "{{ .Values.configs.cfssl.country }}",
            "L": "{{ .Values.configs.cfssl.locale }}",
            "O": "{{ .Values.configs.cfssl.organization }}",
            "OU": "{{ .Values.configs.cfssl.caname }}"",
            "ST": "{{ .Values.configs.cfssl.state }}"
        }
    ]
}
```

- add a newly-signed cert to a OCSP responses file
```cfssl ocspsign -ca cert -responder key -responder-key key -cert cert \
 | cfssljson -bare -stdout >> responses
```

# Bundles
Generate bundle with command run on the cfssl server:
```
cfssl bundle -ca-bundle ca-bundle.crt -int-bundle=int-bundle.crt -cert http-certificate.pem
```

Bundle using the API:
```
curl -d '{"certificate": "-----BEGIN CERTIFICATE-----\nMIICoDCCAkagAwIBAgIUSbd7Bas/Sn0cKi8g+CCDYuzfO40wCgYIKoZIzj0EAwIw\ngYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T\nYW4gRnJhbmNpc2NvMR4wHAYDVQQKExVJbnRlcm5ldCBXaWRnZXRzLCBMTEMxDzAN\nBgNVBAsTBkludCBDQTEbMBkGA1UEAxMSTXktSW50ZXJtZWRpYXRlLUNBMB4XDTE3\nMDMyOTA5MDYwMFoXDTI3MDMyNzA5MDYwMFowgZ8xCzAJBgNVBAYTAlVTMRMwEQYD\nVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMR4wHAYDVQQK\nExVJbnRlcm5ldCBXaWRnZXRzLCBMTEMxHDAaBgNVBAsTE1N5c3RlbXMgRW5naW5l\nZXJpbmcxJTAjBgNVBAMTHGh0dHAuY2Zzc2wuc3ZjLmNsdXN0ZXIubG9jYWwwWTAT\nBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQWexJC601doEq6u42X1CBE+CxotLzyxdMJ\n3qDUB2ZVsZ18Ex0Rho8cTx8JPbLNhKtOj33J8xUaiWuCZgyD8Ydqo3UwczAOBgNV\nHQ8BAf8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwEwDAYDVR0TAQH/BAIwADAd\nBgNVHQ4EFgQUXXrU4D3r/2nrUgmPV5ClxkoEoT4wHwYDVR0jBBgwFoAUBa/BXwl5\nK6zboAMiIsRFUZOkRj8wCgYIKoZIzj0EAwIDSAAwRQIhAOX253Pptmi8pm2NoVHY\n9wXQWNp+EyHETt9MmoImhRtXAiAcB75lKj2RkNYcejnvRuYpWXO0ha1vKK/ovuGm\nTJd2jQ==\n-----END CERTIFICATE-----", "force": "true" }' http://10.99.224.51:8888/api/v1/cfssl/bundle
{"success":false,"result":null,"errors":[{"code":1220,"message":"x509: certificate signed by unknown authority"}],"messages":[]}
```

# Troubleshooting
Check the init container log:
```
kubectl logs http-3902911708-e3lhk -c sign-initial-certs
```

`cfssl gencert -remote=https://http.cfssl.svc.downup.local -profile=client -config config_client.json csr_client.json`

`make overrides | bash`

# TODO
cfssl serve
  -mutual-tls-ca="": Mutual TLS - require clients be signed by this CA
  -mutual-tls-cn="": Mutual TLS - regex for whitelist of allowed client CNs

- take CA + Int CA keys off of nginx container's /etc/nginx/ssl/
- name whitelists
```
{
    "signing": {
        "default": {
            "expiry": "168h"
        },
        "profiles": {
            "www": {
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ],
                "name_whitelist": "^.*\\.cloudflare.com$"
            }
        }
    }
}
```

- swap out static Helm Chart deployment release names
# Resources
https://hub.docker.com/r/cfssl/cfssl/

https://github.com/cloudflare/cfssl/blob/master/doc/bootstrap.txt

# Good cfssl server set-up doc
http://technedigitale.com/archives/639
