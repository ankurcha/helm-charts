# Namespace resource limits Helm Chart

Expected to be used with landscaper to specify per-namespace limits / overrides


TODO

Add Network Policy default policy per-namepace
```
apiVersion: v1
kind: Namespace
metadata:
  name: {{.Release.Namespace}}
  annotations:
    net.beta.kubernetes.io/network-policy: |
      {
        "ingress": {
          "isolation": "DefaultDeny"
        }
      }
```