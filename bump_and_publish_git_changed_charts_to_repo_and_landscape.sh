#! /usr/bin/env bash
# publish changed directories in git, to Helm repo
charts_needing_to_be_published=()

# loop through changed Chart directories
# publish all charts where there's a diff between HEAD and last commit
# Chart version-only changes are omitted, so triggers don't re-trigger the build
while read -r line ; do
    TOP_LEVEL_FILE_CHANGED=$line
    if [ -d $TOP_LEVEL_FILE_CHANGED ]; then
    	grep ^version\: $TOP_LEVEL_FILE_CHANGED/Chart.yaml > /dev/null 2>&1 
    	if [ $? -eq 0 ]; then
    		NON_VERSION_CHANGE_COUNT=`git diff HEAD~1 \
    			$TOP_LEVEL_FILE_CHANGED/Chart.yaml | egrep -e '^[-+]' | \
    			egrep -v '^[-+]version' | egrep -v '^[-+]{3}' | wc -l`
    		if [ $NON_VERSION_CHANGE_COUNT -ne 0 ]; then
    			charts_needing_to_be_published+=("$TOP_LEVEL_FILE_CHANGED")
    		fi
    	fi
    fi
done < <(git diff HEAD~1 --name-only | awk -F/ '{ print $1 }' | sort | uniq)

for chart_to_publish in "${charts_needing_to_be_published[@]}"; do
	make HELM_CHART_NAME=$chart_to_publish bump_version
	make HELM_CHART_NAME=$chart_to_publish publish_helm_chart_to_repo
done