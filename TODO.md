# tag chart versions to repo
	git add $chart_to_publish
	NEW_VERSION=`helm local_bump -f $chart_to_publish/Chart.yaml --bump-level=patch | awk '{ print $NF }'`
	git commit -m "$chart_to_publish/version bump to v$NEW_VERSION"
	git push

# process for deploying updated chart
helm local_bump -f nginx/Chart.yaml --bump-level=patch && make  publish_git_changed_charts_to_repo && helm local_bump -f ../landscape/jenkins/nginx/nginx.yaml --bump-level=patch && make -C ../landscape deploy


# What can drive the below?
helm charts repo gets updated
-> triggers job on "all updated charts"
-> version number becomes "0.2.1-branch+commit_hash"
1. change is made to helm chart
2. triggers bump + publish to Chart repo job + deploy to landscaper
3. 
# helm-charts repo workflow
helm local_bump -f cfssl/Chart.yaml --bump-level=patch
make HELM_CHART_NAME=cfssl publish_helm_chart_to_repo

# landscaper repo workflow
helm local_bump -f cfssl/cfssl.yaml --bump-level=patch
make deploy