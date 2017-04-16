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

add_repo:
	helm repo add $(HELM_REPO_NAME) $(HELM_CHART_REPO)

bump_version:
	helm local_bump -f ${CURDIR}/$(HELM_CHART_NAME)/Chart.yaml --bump-level=patch

publish_git_changed_charts_to_repo:
	./publish_git_changed_charts_to_repo.sh

publish_helm_chart_to_repo:
	./publish_helm_chart_to_repo.sh $(HELM_CHART_NAME)

bump_version_and_publish_helm_chart_to_repo: bump_version publish_helm_chart_to_repo

publish_helm: bump_version_and_publish_helm_chart_to_repo

