HELM_CHART_NAME := please_pass_HELM_CHART_NAME
DOCKER_REPO := us.gcr.io/downup-164000
HELM_CHART_REPO := http://charts.downup.us
HELM_REPO_NAME := charts.downup.us
HELM_REPO_UPLOADER_ENDPOINT := http://localhost:8080/charts

.PHONY: update_dependencies test bump_version publish_helm_chart_to_repo publish_git_changed_charts_to_repo publish

installstarters:
	cp -ir helm-starter-charts/* ~/.helm/starters

update_dependencies:
	helm dependency update $(HELM_CHART_NAME)/

test:
	helm lint $(HELM_CHART_NAME)/
	helm install --dry-run --debug $(HELM_CHART_NAME)/

bump_version:
	helm local_bump -f $(HELM_CHART_NAME)/Chart.yaml --bump-level=patch

add_repo:
	helm repo add $(HELM_REPO_NAME) $(HELM_CHART_REPO)

publish_git_changed_charts_to_repo:
	./publish_git_changed_charts_to_repo_and_landscape.sh

publish_helm_chart_to_repo:
	./publish_helm_chart_to_repo.sh $(HELM_CHART_NAME)

publish: update_dependencies test bump_version publish_helm_chart_to_repo
