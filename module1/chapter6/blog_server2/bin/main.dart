import 'dart:io';
import 'package:blog_server/blogserver.dart';

var host = '127.0.0.1';
var port = 3000;

main() async {
  print('starting');
  var blogServer = BlogServerApp();
  await blogServer.hostedBlog.initBlog();
  print('Starting blog server...');

  HttpServer.bind(host, port).then((server) {
    server.listen(blogServer.handleRequest);
  });
}
