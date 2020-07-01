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
LIBRA2API_URL=http://docker1.lib.virginia.edu:8040
LIBRA2_URL=http://docker1.lib.virginia.edu:8040
USERINFO_URL=http://docker1.lib.virginia.edu:8240
OPTREG_CNAME=optregdev.lib.virginia.edu

DOCKER_ENV="-e API_TOKEN=$API_TOKEN -e LIBRA2API_URL=$LIBRA2API_URL -e LIBRA2_URL=$LIBRA2_URL -e OPTREG_CNAME=$OPTREG_DEV_CNAME -e USERINFO_URL=$USERINFO_URL"

$DOCKER_TOOL run -t -i -p 8222:3000 $DOCKER_ENV $NAMESPACE/$INSTANCE /bin/bash -l
