import 'dart:io';
import 'package:blog_server/blogserver.dart';

main() async {
  print('starting');
  var blogServer = BlogServerApp();
  await blogServer.hostedBlog.initBlog();
  print('Starting blog server...');

  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen(blogServer.handleRequest);
  });
}
