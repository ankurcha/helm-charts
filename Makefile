HELM_CHART_NAME := please_pass_HELM_CHART_NAME
DOCKER_REPO := us.gcr.io/downup-164000
HELM_CHART_REPO := http://charts.downup.us
HELM_REPO_NAME := charts.downup.us
HELM_REPO_UPLOADER_ENDPOINT := http://localhost:8080/charts

.PHONY: lint_helm bump_version_and_publish_helm_chart_to_repo publish_helm

installstarters:
	cp -ir helm-starter-charts/* ~/.helm/starters

lint_helm:
	helm lint $(HELM_CHART_NAME)/

bump_version_and_publish_helm_chart_to_repo:
	helm repo add $(HELM_REPO_NAME) $(HELM_CHART_REPO)

	helm local_bump -f ${CURDIR}/$(HELM_CHART_NAME)/Chart.yaml --bump-level=patch
	./publish_helm.sh $(HELM_CHART_NAME)

publish_helm: bump_version_and_publish_helm_chart_to_repo

