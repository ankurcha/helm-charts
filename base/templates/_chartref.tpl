{{- /*
from https://github.com/technosophos/common-chart/blob/eb0f6fe3dfbfafbfde7767213c0d57bab53b176c/common/templates/_chartref.tpl

common.chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
Example output:
  zookeeper-1.2.3
  wordpress-3.2.1_20170219
*/ -}}
{{- define "common.chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}
