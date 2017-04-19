# Postgresql Helm Chart

## Testing with Helm/Landscaper
```
helm package apps/postgresql/helm/postgresql && rm postgresql-*.tgz  && find /var/folders/ -name postgresql-*.tgz -exec rm {} \; 2&1 > /dev/null ; POSTGRES_USER=sramey POSTGRES_PASSWORD=sramey landscaper apply --dir landscape/postgresql --namespace postgresql -v 9
```
TODO
- TLS
- Replication
- Multi-master setup