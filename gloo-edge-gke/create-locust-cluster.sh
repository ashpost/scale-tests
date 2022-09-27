#!/bin/sh

set -e
set -o pipefail

_filename="$(basename $BASH_SOURCE)"

DEFAULT_NODE_NUM="1"
DEFAULT_REGION="australia-southeast1"
DEFAULT_INSTANCE_TYPE="e2-standard-16"
DEFAULT_CLUSTER_VERSION="1.23"

OWNER="ash"
NODE_NUM="1"
CLUSTER_NAME_SUFFIX="locust-client"
CLUSTER_VERSION=$DEFAULT_CLUSTER_VERSION
REGION=$DEFAULT_REGION

echo "Creating cluster $OWNER-$CLUSTER_NAME_SUFFIX with $NODE_NUM nodes of type $INSTANCE_TYPE"

gcloud container clusters create "$OWNER-$CLUSTER_NAME_SUFFIX" \
	--project "field-engineering-apac" --region "$REGION" \
	--cluster-version "$CLUSTER_VERSION" \
	--labels=created-by=$OWNER \
	--machine-type "$DEFAULT_INSTANCE_TYPE" --network "default" --subnetwork "default" \
	--enable-autoscaling --min-nodes "1" --max-nodes "2" \
	--addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
	--enable-autoupgrade --enable-autorepair --enable-ip-alias \
	--max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes

