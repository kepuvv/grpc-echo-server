# Build stage (arm64 native build; generates proto inside)
FROM --platform=$BUILDPLATFORM golang:1.23-bullseye AS builder

# Install git and protoc
RUN apt-get update && apt-get install -y git protobuf-compiler && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy module files
COPY go.mod ./
RUN go mod download

# Install protoc plugins
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31.0
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

# Copy proto and generate code (fresh; do not copy local generated files)
COPY echo.proto ./
RUN mkdir -p echo && \
    protoc --go_out=echo --go_opt=paths=source_relative \
           --go-grpc_out=echo --go-grpc_opt=paths=source_relative \
           echo.proto

# Copy source code
COPY main.go ./

# Update dependencies
RUN go mod tidy

# Build the application (native; default arm64 on M4)
ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH:-arm64} go build -o grpc-server .

# Final stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/grpc-server .

EXPOSE 50051

CMD ["./grpc-server"]

