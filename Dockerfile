FROM elixir:1.10.4-alpine

WORKDIR /app
ADD . /app

# For live reload
RUN apk add --update inotify-tools nodejs npm

# Install hex & rebar
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

EXPOSE 4000

# Intall phoenix
# ENV PHOENIX_VERSION=1.5.4
RUN mix archive.install hex phx_new --force
