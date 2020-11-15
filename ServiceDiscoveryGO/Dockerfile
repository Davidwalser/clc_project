FROM golang:latest
RUN mkdir /app
ADD serviceDiscovery.go /app/
WORKDIR /app
# RUN go get
COPY go.mod .
COPY go.sum .
RUN go mod download
RUN go build -o service .
# CMD ["./service"]