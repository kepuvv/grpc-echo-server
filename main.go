package main

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	pb "grpc-echo-server/echo"
)

const (
	port = ":50051"
)

// server is used to implement echo.EchoServiceServer.
type server struct {
	pb.UnimplementedEchoServiceServer
}

// Echo implements echo.EchoServiceServer
func (s *server) Echo(ctx context.Context, in *pb.EchoRequest) (*pb.EchoResponse, error) {
	log.Printf("Echo received: %v", in.GetMessage())
	return &pb.EchoResponse{Message: in.GetMessage()}, nil
}

// SayHello implements echo.EchoServiceServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloResponse, error) {
	log.Printf("SayHello received: %v", in.GetName())
	return &pb.HelloResponse{Message: "Hello " + in.GetName()}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()

	// Register the EchoService
	pb.RegisterEchoServiceServer(s, &server{})

	// Enable gRPC reflection for grpcurl
	reflection.Register(s)

	log.Printf("gRPC server listening on %s", port)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

