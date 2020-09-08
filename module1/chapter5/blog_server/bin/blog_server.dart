import 'dart:io';

const address = '127.0.0.1';
const port = 8080;

void main(List<String> arguments) {
  HttpServer.bind(address, port).then((server) {
    print('Server is running at $address:$port');
    server.listen((HttpRequest request) {
      request.response
        ..write('Hello Dart World!')
        ..close();
    });
  });
}
