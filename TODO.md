# tag chart versions to repo
	git add $chart_to_publish
	NEW_VERSION=`helm local_bump -f $chart_to_publish/Chart.yaml --bump-level=patch | awk '{ print $NF }'`
	git commit -m "$chart_to_publish/version bump to v$NEW_VERSION"
	git push

# process for deploying updated chart
helm local_bump -f nginx/Chart.yaml --bump-level=patch && make  publish_git_changed_charts_to_repo && helm local_bump -f ../landscape/jenkins/nginx/nginx.yaml --bump-level=patch && make -C ../landscape deploy