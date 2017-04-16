#! /usr/bin/env bash
# publish changed directories in git, to Helm repo
charts_needing_to_be_published=()

# loop through changed Chart directories
# publish all charts where there's a diff between HEAD and last commit
# Chart version-only changes are omitted, so triggers don't re-trigger the build
while read -r line ; do
    TOP_LEVEL_FILE_CHANGED=$line
    if [ -d $TOP_LEVEL_FILE_CHANGED ]; then
	# this is really a chart?
    	grep ^version\: $TOP_LEVEL_FILE_CHANGED/Chart.yaml > /dev/null 2>&1 
    	if [ $? -eq 0 ]; then
               CHART_YAML_NON_VERSION_CHANGES=`git diff HEAD~1 \
                       $TOP_LEVEL_FILE_CHANGED/Chart.yaml | egrep -e '^[-+]' | \
    			egrep -v '^[-+]version' | egrep -v '^[-+]{3}' | wc -l`
		CHART_OTHER_FILES_CHANGES=`git diff HEAD~1 . ':(exclude)*/Chart.yaml' | \
			egrep -e '^[-+]' | egrep -v '^[-+]version' | egrep -v '^[-+]{3}' | wc -l`
    		if [ $CHART_YAML_NON_VERSION_CHANGES -ne 0 ] || \
			[ $CHART_OTHER_FILES_CHANGES -ne 0 ]; then
    			charts_needing_to_be_published+=("$TOP_LEVEL_FILE_CHANGED")
    		fi
    	fi
    fi
done < <(git diff HEAD~1 --name-only | awk -F/ '{ print $1 }' | sort | uniq)

for chart_to_publish in "${charts_needing_to_be_published[@]}"; do
	make HELM_CHART_NAME=$chart_to_publish bump_version
	make HELM_CHART_NAME=$chart_to_publish publish_helm_chart_to_repo
done
