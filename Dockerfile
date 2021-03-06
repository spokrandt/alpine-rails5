FROM alpine:latest
ENV BUILD_PACKAGES="curl-dev ruby-dev build-base python2 bash git py-pip python-dev" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev postgresql-dev mysql-dev libxml2-dev" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml nodejs" \
    RAILS_VERSION="5.2.0"
 
RUN \
  apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  gem install -N bundler --pre && \
  pip install --isolated Flask && \
  pip install vpython
 
RUN \
  gem install -N pkg-config -v "~> 1.1" && \
  gem install -N nokogiri && \
  gem install -N rails --version "$RAILS_VERSION" && \
  gem install -N public_suffix -v '3.0.2' && \
  gem install -N addressable -v '2.5.2' && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \

  # cleanup and settings
  bundle config --global build.nokogiri "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem 
