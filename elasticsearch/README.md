# elasticsearch Helm Chart

Requirements: namespace Helm Chart

# TODO
- apply HPA for custom metrics, configured via an annotation. The value in the annotation is interpreted as a target metric value averaged over all running pods. Example:
```
    annotations:
      alpha/target.custom-metrics.podautoscaler.kubernetes.io: '{"items":[{"name":"qps", "value": "10"}]}'
```
https://github.com/vvanholl/elasticsearch-prometheus-exporter

- heapster integration w/ HPA
deleted replicas: tag in statefulset