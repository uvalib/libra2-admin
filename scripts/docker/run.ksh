#if [ -z "$DOCKER_HOST" ]; then
#   echo "ERROR: no DOCKER_HOST defined"
#   exit 1
#fi

if [ -z "$DOCKER_HOST" ]; then
   DOCKER_TOOL=docker
else
   DOCKER_TOOL=docker-17.04.0
fi

# set the definitions
INSTANCE=libra-etd-admin
NAMESPACE=uvadave

# environment attributes
API_TOKEN=94DE1D63-72F1-44A1-BC7D-F12FC951

DOCKER_ENV="-e API_TOKEN=$API_TOKEN"

# stop the running instance
$DOCKER_TOOL stop $INSTANCE

# remove the instance
$DOCKER_TOOL rm $INSTANCE

# remove the previously tagged version
$DOCKER_TOOL rmi $NAMESPACE/$INSTANCE:current  

# tag the latest as the current
$DOCKER_TOOL tag -f $NAMESPACE/$INSTANCE:latest $NAMESPACE/$INSTANCE:current

$DOCKER_TOOL run -d -p 8222:3000 $DOCKER_ENV --name $INSTANCE $NAMESPACE/$INSTANCE:latest

# return status
exit $?
