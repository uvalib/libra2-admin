#if [ -z "$DOCKER_HOST" ]; then
#   echo "ERROR: no DOCKER_HOST defined"
#   exit 1
#fi

if [ -z "$DOCKER_HOST" ]; then
   DOCKER_TOOL=docker
else
   DOCKER_TOOL=docker-legacy
fi

# set the definitions
INSTANCE=libra-etd-admin
NAMESPACE=uvadave

$DOCKER_TOOL run -t -i -p 8080:8080 $NAMESPACE/$INSTANCE /bin/bash -l
