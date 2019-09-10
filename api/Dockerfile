FROM golang:1.12.9 AS build

WORKDIR /app
COPY . /app
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build

# FROM scratch
# WORKDIR /app
# COPY --from=build /app/bperf_api ./
ENTRYPOINT ["/app/bperf_api"]
