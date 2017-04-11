# Kubernetes Helm Charts

A collection of Landscaper-compatible Kubernetes Helm Charts

Template "starter charts" are in the [helm-starter-charts/](helm-starter-charts/) directory

To create a helm chart from a "starter" chart:
```
make installstarters # Copy all starters to your ~/.helm/starters/ directory:
cd myapp && mkdir helm # Create helm/ directory in your application repo
helm create -p http-starter myapp # Create your Helm chart
```

TODO: to deploy a specific chart, run:
```
make -C chart_name publish_helm
```

