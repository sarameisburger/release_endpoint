FROM ruby:latest
MAINTAINER sara.meisburger@puppet.com


#RUN yum -y install ruby rubygems ruby-devel rubygem-nokogiri rubygem-bundler rubygem-json gcc make gcc-c++
RUN gem install  --no-rdoc --no-ri sinatra thin shotgun nokogiri json bundler
EXPOSE 8334
## The application will run out of /release_endpoint as the user release_endpoint
RUN useradd release_endpoint
RUN mkdir -p /release_endpoint
COPY views /release_endpoint/views
COPY public /release_endpoint/public
ADD  app.rb /release_endpoint/app.rb
#RUN chown -R release_endpoint:release_endpoint /release_endpoint
CMD ruby /release_endpoint/app.rb
