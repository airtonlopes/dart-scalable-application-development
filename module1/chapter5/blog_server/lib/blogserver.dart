// the BlogServer library
library blog_server;

import 'dart:io';
import 'package:path/path.dart' as path;

import 'blog.dart';
import 'content.dart';

class BlogServerApp {
  File image;
  Blog hostedBlog;
  var png;

  var BlogTitle = 'Greatest Animal Facis Blog';

  BlogServerApp() {
    var srcPath = path.join(Directory.current.path, 'content/posts');
    var imgPath = path.join(Directory.current.path, 'content/img');
    hostedBlog = Blog(srcPath, imgPath);
  }

  /// Get request type and process accordingly
  void handleRequest(HttpRequest request) {
    if (request.uri.path.endsWith('.html')) {
      _serveTextFile(request);
    } else if (request.uri.path.endsWith('.png')) {
      _servePngFile(request);
    } else if (request.uri.path == '/robots.txt') {
      _serveRobotsFile(request);
    } else {
      _serve404(request);
    }
  }

  // Serve all text format files
  void _serveTextFile(HttpRequest request) {
    var content = _getContent(request.uri.path.toString());

    final markup = '''<html>
    <head><title>$BlogTitle</title></head>
    <body>
    $content
    </body>
    </html>
    ''';

    request.response
      ..headers.set('Content-Type', 'text/html; charset=utf-8')
      ..statusCode = HttpStatus.ok
      ..write(markup)
      ..close();
  }

  // Serve a PNG file.
  void _servePngFile(HttpRequest request) {
    var imgp = request.uri.path.toString();
    imgp = imgp.replaceFirst('.png', '').replaceFirst('/', '');

    image = hostedBlog.getBlogImage(int.parse(imgp));
    image.readAsBytes().then((raw) {
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.set('Content-Type', 'image/png')
        ..headers.set('Content-Length', raw.length)
        ..add(raw)
        ..close();
    });
  }

  // Serve a Robots.txt File
  void _serveRobotsFile(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.set('Content-Type', 'text/html; charset=utf-8')
      ..write(RobotsTxt)
      ..close();
  }

  // Serve a 404 if an unknown response is requested.
  void _serve404(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..headers.set('Content-Type', 'text/html; charset=utf-8')
      ..write(page404)
      ..close();
  }

  // Build the content for the requested path.
  String _getContent(String path) {
    if (path == '/index.html') {
      return hostedBlog.getFrontPage();
    }

    if (path.startsWith('/post')) {
      var idFromUrl = path.replaceFirst('/post', '').replaceFirst('.html', '');
      var id = int.parse(idFromUrl);
      return hostedBlog.getBlogPost(id).HTML;
    }

    return '';
  }
}
