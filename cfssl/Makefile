SHELL=/bin/bash

KUBERNETES_CONTEXT?=cluster
VAULT_ADDR?=http://127.0.0.1:8200
CHART_NAME := cfssl
KUBERNETES_NAMESPACE?=$(CHART_NAME)-ERROR-UNSPECIFIED-IN-CHART

NAMESPACE_ALREADY_EXISTS := $(shell kubectl get namespace $(KUBERNETES_NAMESPACE) --context=$(KUBERNETES_CONTEXT) 2>&1 > /dev/null && echo "yes" || echo "no")

all: write-helm-overrides deploy

populate-vault-with-defaults:
	@echo "Making target populate-vault-with-defaults"
	@(../../generate-confd-templates.py --kube-context=$(KUBERNETES_CONTEXT) --namespace=$(KUBERNETES_NAMESPACE) --chart=$(CHART_NAME) --chart-path=. --bash | bash) 2>&1 > /dev/null

backend-get:
	@echo "Making target backend-get"
	vault read secret/$(KUBERNETES_CONTEXT)/$(KUBERNETES_NAMESPACE)/$(CHART_NAME)

write-helm-overrides:
	@echo "Making target write-helm-overrides"
	@confd -backend vault -confdir confd-overrides -auth-type token -auth-token $$(vault read -field id auth/token/lookup-self) -node $(VAULT_ADDR) -onetime 2> /dev/null #-log-level debug 

deploy:
# create values.overrides.yaml first
	@echo "Making target deploy"
ifneq ($(NAMESPACE_ALREADY_EXISTS),yes)
	@kubectl create ns $(KUBERNETES_NAMESPACE) --context=$(KUBERNETES_CONTEXT)
#	kubectl create serviceaccount default --namespace=$(KUBERNETES_NAMESPACE) --context=$(KUBERNETES_CONTEXT)
endif
	@touch values.overrides.yaml
	@helm upgrade $(CHART_NAME) . -i --namespace $(KUBERNETES_NAMESPACE) --kube-context=$(KUBERNETES_CONTEXT) -f values.yaml -f values.overrides.yaml --set kubecontext=$(KUBERNETES_CONTEXT) --wait --timeout 300

delete:
	@echo "Making target delete"
	helm delete $(CHART_NAME) --kube-context=$(KUBERNETES_CONTEXT)

purge purge-pvc-data:
	@echo "Making target purge-pvc-data"
	helm delete $(CHART_NAME) --kube-context=$(KUBERNETES_CONTEXT) --purge

.PHONY: all populate-vault-with-defaults backend-get write-helm-overrides deploy delete purge-pvc-data purge
