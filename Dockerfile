#syntax=docker/dockerfile:experimental
FROM golang:1.15-alpine as build
WORKDIR /code
COPY go.mod go.sum ./
RUN --mount=type=cache,target=~/.cache/pip \
  go mod download
COPY . .
RUN --mount=type=cache,target=~/.cache/pip \
  GO111MODULE=on go build -o app

FROM alpine:3.14 as runtime
COPY --from=build /code/app . 
CMD ["./app"]
