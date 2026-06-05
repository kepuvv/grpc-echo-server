# gRPC Echo Server

Simple gRPC server for grpcurl tool without proto files

## Build Docker image

Build for linux/amd64
```bash
docker buildx build --platform linux/amd64 -t grpc-echo-server .
```

## Run

```bash
docker run --rm -d -p 50051:50051 --name grpc-server grpc-echo-server
```

## Use

```bash
./grpcurl -plaintext localhost:50051 list
```

Response must contain all availible methods:
```
echo.EchoService
grpc.reflection.v1alpha.ServerReflection
grpc.reflection.v1.ServerReflection
```

```bash
# Echo method
./grpcurl -plaintext localhost:50051 echo.EchoService/Echo -d '{"message": "Hello World"}'

# SayHello method
./grpcurl -plaintext localhost:50051 echo.EchoService/SayHello -d '{"name": "World"}'
```

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-kepuvv/grpc_echo_reflection-blue?logo=docker)](https://hub.docker.com/r/kepuvv/grpc-echo-reflection)
![Docker Pulls](https://img.shields.io/docker/pulls/kepuvv/grpc-echo-reflection)
