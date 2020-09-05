import 'dart:io';

void main(List<String> arguments) {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
      request.response
        ..write('Hello Dart World')
        ..close;
    });
  });
}
