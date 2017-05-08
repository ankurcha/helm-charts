#! /usr/bin/env bash

if [ -z ${1+x} ]; then
  echo "Usage: $0 chart_name";
  exit 1
fi

HELM_CHART_NAME=$1

DOCKER_REPO=us.gcr.io/downup-164000
HELM_CHART_REPO=http://charts.downup.us
HELM_REPO_NAME=charts.downup.us
HELM_REPO_UPLOADER_ENDPOINT=http://localhost:8080/charts

helm repo add $HELM_REPO_NAME $HELM_CHART_REPO

mkdir -p $PWD/$HELM_CHART_NAME/build
rm -f $PWD/$HELM_CHART_NAME/build/${HELM_CHART_NAME}-*.tgz

# TODO: signing of charts
# helm package --sign --key 'D84669B161B026671A86575290FBE1F81D70695D' \
#       --keyring ~/.gnupg/secring.gpg -d build/ $(HELM_CHART_NAME)/

# update dependencies and place them in charts/ directory
helm dependency update $PWD/$HELM_CHART_NAME

export HELM_PACKAGE_FILE=`helm package $PWD/$HELM_CHART_NAME \
                          -d $PWD/$HELM_CHART_NAME/build --debug --save=false \
                          | grep -v "Warning" | awk '{ print \$3 }'`

echo HELM_PACKAGE_FILE=$HELM_PACKAGE_FILE
curl -i -X PUT -F repo=default -F chart=@$HELM_PACKAGE_FILE \
	$HELM_REPO_UPLOADER_ENDPOINT # preferably inside the cluster, but doesn't have to be
rm $HELM_PACKAGE_FILE

