import 'dart:io';
import 'package:blog_server/blogserver.dart';

import 'blog_server.dart';

void main() {
  const host = '127.0.0.1';
  const port = 8080;

  print('starting');
  var blogServer = BlogServerApp();
  print('Starting blog server at $host:$port ...');

  HttpServer.bind(address, port).then((server) {
    server.listen(blogServer.handleRequest);
  });
}
