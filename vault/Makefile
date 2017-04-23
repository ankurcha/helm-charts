SHELL=/bin/bash

KUBERNETES_CONTEXT?=cluster
CHART_NAME := vault
NAMESPACE := $(CHART_NAME)

NAMESPACE_ALREADY_EXISTS := $(shell kubectl get namespace $(NAMESPACE) --context=$(KUBERNETES_CONTEXT) 2>&1 > /dev/null && echo "yes" || echo "no")

PVC_NAMES := dbdata initial-cert-store
# kubectl get pvc initial-cert-store --template={{.spec.volumeName}}
# kubectl get pvc dbdata --template={{.spec.volumeName}}

all: populate-backends confd deploy

populate-backends:
	@../../generate-confd-templates.py --kube-context=$(KUBERNETES_CONTEXT) --chart=$(CHART_NAME) --bash | bash

confd:
	confd -onetime -backend consul -confdir confd-configs -log-level debug
	export ROOT_TOKEN=$$(vault read -field id auth/token/lookup-self)
	confd -backend vault -confdir confd-secrets -auth-type token -auth-token $$ROOT_TOKEN -node http://127.0.0.1:8200 -log-level debug -onetime

deploy:
# create values.overrides.yaml first
ifneq ($(NAMESPACE_ALREADY_EXISTS),yes)
	kubectl create ns $(NAMESPACE) --context=$(KUBERNETES_CONTEXT)
endif
	helm upgrade $(CHART_NAME) . -i --namespace $(NAMESPACE) --kube-context=$(KUBERNETES_CONTEXT) -f values.yaml -f values.configs.yaml -f values.secrets.yaml --set context=$(KUBERNETES_CONTEXT)

delete:
ifeq ($(NAMESPACE_ALREADY_EXISTS),yes)
	-helm delete $(CHART_NAME) --kube-context=$(KUBERNETES_CONTEXT)
	kubectl delete namespace $(NAMESPACE) --cascade=false
endif

setoverrides:
	./override-secrets.py --kube-context=$(KUBERNETES_CONTEXT) --chart=$(CHART_NAME) --bash

purge: delete

.PHONY: all populate-backends confd deploy delete purge
