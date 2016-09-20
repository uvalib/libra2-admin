FROM alpine:3.4

# Add necessary packages
RUN apk --update add bash tzdata ruby ruby-dev build-base nodejs sqlite-dev zlib-dev libxml2-dev libxslt-dev libffi-dev ca-certificates

# Create the run user and group
RUN addgroup webservice && adduser webservice -G webservice -D

# set the timezone appropriatly
ENV TZ=EST5EDT
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Specify home 
ENV APP_HOME /libra2-admin
WORKDIR $APP_HOME

# Add necessary assets and gems that require native extensions
RUN gem install bundler io-console --no-ri --no-rdoc
RUN gem install \
nio4r:1.2.1 \
byebug:9.0.5 \
debug_inspector:0.0.2 \
ffi:1.9.14 \
json:2.0.2 \
puma:3.6.0 \
nokogiri:1.6.8 \
websocket-driver:0.6.4 \
bigdecimal:1.2.7 \
--no-ri --no-rdoc

# install the app and bundle
COPY . $APP_HOME
RUN rm $APP_HOME/Gemfile.lock
RUN bundle install
RUN rake assets:precompile

# Update permissions
RUN chown -R webservice $APP_HOME && chgrp -R webservice $APP_HOME

# Specify the user
USER webservice

# define port and startup script
EXPOSE 3000
CMD /bin/bash -l -c "scripts/entry.sh"

# move in the profile
COPY data/container_bash_profile /home/webservice/.profile
