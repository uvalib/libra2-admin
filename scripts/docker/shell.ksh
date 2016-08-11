if [ -z "$DOCKER_HOST" ]; then
   echo "ERROR: no DOCKER_HOST defined"
   exit 1
fi

# set the definitions
INSTANCE=libra2-admin
NAMESPACE=uvadave

# environment attributes
API_TOKEN=94DE1D63-72F1-44A1-BC7D-F12FC951

DOCKER_ENV="-e API_TOKEN=$API_TOKEN"

docker run -t -i -p 8222:3000 $DOCKER_ENV $NAMESPACE/$INSTANCE /bin/bash -l
