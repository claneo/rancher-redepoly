#!/bin/sh

# check enviroment variables

if [ -z $ENDPOINT ]; then
  echo "Need to set ENDPOINT"
  exit 1
fi
if [ -z $TOKEN ]; then
  echo "Need to set TOKEN"
  exit 1
fi
if [ -z $CLUSTER ]; then
  echo "Need to set CLUSTER"
  exit 1
fi

host=$ENDPOINT
token=$TOKEN
cluster=$CLUSTER

project=$1
namespace=$2
deployment=$3

if [ "$#" -ne 3 ]; then 
  echo "USAGE: docker run --rm rancher-redeploy project namespace deployment"
  exit 1
fi

echo endpoint: $host
echo token: "******"
echo cluster: $cluster
echo project: $project
echo namespace: $namespace
echo deployment: $deployment

clusterId=$(curl -ks -u $token $host/clusters?name=$cluster | jq ".data[0].id" -r) 
projectId=$(curl -ks -u $token  $host/clusters/$clusterId/projects?name=$project | jq ".data[0].id" -r)
deploymentData=$(curl -ks -u $token  $host/projects/$projectId/workloads/deployment:$namespace:$deployment)
currentTime=$(date +%s)

response=$(curl -ks -u $token  $host/projects/$projectId/workloads/deployment:$namespace:$deployment \
  | jq ".annotations.\"cattle.io/timestamp\" = ${currentTime}" \
  | curl -ks -u $token $host/projects/$projectId/workloads/deployment:$namespace:$deployment \
  -X PUT -H 'Content-Type: application/json' -o /dev/null -w "%{http_code}" --data-binary @-)

if [[ $response != "200" ]]; then
  echo "error!"
  exit 1
else
  echo "Redepoly finished!"
fi