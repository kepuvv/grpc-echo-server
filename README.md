# gRPC Echo Server

Простой gRPC сервер с включенным reflection для работы с grpcurl без proto файлов.

## Сборка Docker образа

Сборка для linux/amd64 с использованием buildx (рекомендуется на M4 MacBook):
```bash
docker buildx build --platform linux/amd64 -t grpc-echo-server .
```

Или обычная сборка:
```bash
docker build --build-arg TARGETOS=linux --build-arg TARGETARCH=amd64 -t grpc-echo-server .
```

## Запуск контейнера

```bash
docker run -d -p 50051:50051 --name grpc-server grpc-echo-server
```

## Проверка работы

После запуска контейнера можно проверить доступность сервера:

```bash
./grpcurl -plaintext localhost:50051 list
```

Должен вывести список доступных сервисов, например:
```
echo.EchoService
grpc.reflection.v1alpha.ServerReflection
grpc.reflection.v1.ServerReflection
```

Для вызова методов:

```bash
# Echo метод
./grpcurl -plaintext localhost:50051 echo.EchoService/Echo -d '{"message": "Hello World"}'

# SayHello метод
./grpcurl -plaintext localhost:50051 echo.EchoService/SayHello -d '{"name": "World"}'
```

## Остановка контейнера

```bash
docker stop grpc-server
docker rm grpc-server
```

