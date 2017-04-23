from https://hub.docker.com/_/vault/:

$ docker run --cap-add=IPC_LOCK -e 'VAULT_LOCAL_CONFIG={"backend": {"file": {"path": "/vault/file"}}, "default_lease_ttl": "168h", "max_lease_ttl": "720h"}' vault server

CAP_IPC_LOCK explained: https://kubernetes.io/docs/user-guide/containers/