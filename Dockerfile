# Create statically-linked golang application 
# using docker's multi-stage build feature. 
# Uses docker build cache
# Only re-download changed dependencies 
FROM golang:1.17-alpine as builder
# issue https://github.com/GoogleContainerTools/kaniko/issues/1297
RUN chown -R 777 /var/run/secrets && rm -rf /var/run/secrets
RUN apk update && apk upgrade --force-overwrite && \
    apk add --no-cache git

RUN mkdir /app
# Set the Current Working Directory inside the container
WORKDIR /app/sim-be-p2p

ENV GO111MODULE=on
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Build the Go app
RUN cd cmd && CGO_ENABLED=0 GOOS=linux  go build -a -installsuffix cgo -o ../out/sim-be-p2p .

# Run container
FROM alpine:latest
# issue https://github.com/GoogleContainerTools/kaniko/issues/1297
RUN chown -R 777 /var/run/secrets && rm -rf /var/run/secrets
# Update and upgrade packages in a writable environment
RUN apk update && apk upgrade --force-overwrite --no-cache && \ 
    apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app/sim-be-p2p
# Copy the statically-linked binary into a alpine container.
COPY --from=builder /app/sim-be-p2p .
# This container exposes port 8080 to the outside world
EXPOSE 8080
# Run the binary program produced by `go install`
ENTRYPOINT ["./sim-be-p2p.sh"]