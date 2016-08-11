if [ -z "$DOCKER_HOST" ]; then
   echo "ERROR: no DOCKER_HOST defined"
   exit 1
fi

# set the definitions
INSTANCE=libra2-administration
NAMESPACE=uvadave

# environment attributes
API_TOKEN=94DE1D63-72F1-44A1-BC7D-F12FC951

DOCKER_ENV="-e API_TOKEN=$API_TOKEN"

# stop the running instance
docker stop $INSTANCE

# remove the instance
docker rm $INSTANCE

# remove the previously tagged version
docker rmi $NAMESPACE/$INSTANCE:current  

# tag the latest as the current
docker tag -f $NAMESPACE/$INSTANCE:latest $NAMESPACE/$INSTANCE:current

docker run -d -p 8222:3000 $DOCKER_ENV --name $INSTANCE $NAMESPACE/$INSTANCE:latest

# return status
exit $?
