# syntax=docker/dockerfile:1

ARG VERSION=3.0.18
FROM golang:1.18 AS build

WORKDIR /app

COPY protonmail-bridge/go.mod ./
COPY protonmail-bridge/go.sum ./

RUN go mod download

COPY . ./

# RUN ls -lR

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    build-essential git mercurial ca-certificates libsecret-1-dev pkg-config
RUN cd protonmail-bridge && make build-nogui


FROM alpine:latest

COPY --from=build /app/protonmail-bridge/proton-bridge /usr/bin/proton-bridge

ENTRYPOINT [ "/usr/bin/proton-bridge" ]
