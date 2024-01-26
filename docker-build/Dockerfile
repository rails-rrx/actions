ARG BUILD_RUBY_VERSION=3.2.2
ARG BASE_IMAGE=ruby

FROM ${BASE_IMAGE}:${BUILD_RUBY_VERSION} AS base

ARG BUILD_GEM_VERSION=3.3.5
ARG BUILD_BUNDLER_VERSION=2.3.5

RUN apt-get update -yqq \
        && apt-get install -y apt-utils \
        && apt-get install -y curl

#        && apt-get update -y \
#        && apt-get install -y netcat \
#        && apt-get -q clean

ENV APP_ROOT=/opt/app
RUN mkdir -p ${APP_ROOT}
WORKDIR ${APP_ROOT}

#RUN echo "Installing rubygems ${BUILD_GEM_VERSION}..."
#RUN gem update --system ${BUILD_GEM_VERSION}
RUN echo "Installing rubygems..."
RUN gem update --system
RUN echo "Installing bundler ${BUILD_BUNDLER_VERSION}..."
RUN gem install bundler -v $BUILD_BUNDLER_VERSION

#  Full image which automatically sets up Rails app
FROM base AS rails

# Install dependencies
COPY Gemfile* ${APP_ROOT}/
RUN bundle config set deployment 'true'
RUN bundle config set --local without 'development test'
RUN bundle install
RUN bundle binstubs --all

# Install app
COPY . ${APP_ROOT}/

# Puma support
RUN mkdir -p ${APP_ROOT}/tmp/pids
