FROM floze/raspbian-passenger-ruby23:0.9.19
MAINTAINER floze <gammafloze@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Expose Nginx HTTP service
EXPOSE 80

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
ADD nginx.conf /etc/nginx/conf.d/nginx.conf
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf
ADD app.conf /etc/nginx/sites-enabled/app.conf

# Install bundle of gems
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install --jobs=3 --retry=3

# Add the Rails app
WORKDIR /home/app
ADD . /home/app
RUN chown -R app:app /home/app

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*