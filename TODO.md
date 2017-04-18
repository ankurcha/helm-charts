	git add $chart_to_publish
	NEW_VERSION=`helm local_bump -f $chart_to_publish/Chart.yaml --bump-level=patch | awk '{ print $NF }'`
	git commit -m "$chart_to_publish/version bump to v$NEW_VERSION"
	git push
