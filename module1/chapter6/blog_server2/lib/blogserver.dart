library blog_server;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';

import 'package:blog_server/blog.dart';
import 'package:blog_server/content.dart';
import 'package:blog_server/log.dart';

/// The BlogServer application object.
class BlogServerApp {
  File image;
  Blog hostedBlog;
  var png;

  String blogTitle = 'Greatest Animal Facts Blog';

  BlogServerApp() {
    var srcPath = path.join(Directory.current.path, 'content/posts');
    var imgPath = path.join(Directory.current.path, 'content/img');
    hostedBlog = Blog(srcPath, imgPath);
  }

  /// Get request type and process accordinary
  handleRequest(HttpRequest request) {
    log(request);

    if (request.method == 'POST') {
      _handleFormPost(request);
    } else if (request.uri.path == '/admin') {
      _serveAdminLogin(request);
    } else if (request.uri.path == '/feed.xml') {
      _serveRSSFeed(request);
    } else if (request.uri.path.endsWith('.html')) {
      _serveTextFile(request);
    } else if (request.uri.path.endsWith('.json')) {
      _serveJsonFile(request);
    } else if (request.uri.path.endsWith('.png')) {
      _servePngFile(request);
    } else if (request.uri.path == '/robots.txt') {
      _serveRobotsFile(request);
    } else {
      _serve404(request);
    }
  }

  // Return login or post form
  void _handleFormPost(HttpRequest request) {
    if (request.uri.path == '/login') _performLogin(request);
    if (request.uri.path == '/add') _performNewPost(request);
  }

  // Returns login form
  void _serveAdminLogin(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.set('Content-Type', 'text/html; charset=utf8')
      ..write(loginForm)
      ..close();
  }

  /// Return response XML Feed RSS
  void _serveRSSFeed(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.set('Content-Type', 'application/rss+xml')
      ..write(hostedBlog.getRSSFeed())
      ..close();
  }

  // Serve all text format files
  void _serveTextFile(HttpRequest request) {
    String content = _getContent(request.uri.path.toString());

    String marckup = '''<html>
    <head>
      <meta charset="utf-8">
      <title>$blogTitle</title>
    </head>
    <body>
    $content
    </body>
    </html>
    ''';

    request.response
      ..statusCode = HttpStatus.ok
      ..headers.set('Content-Type', 'text/html; charset=utf8')
      ..write(marckup)
      ..close();
  }

  // Build the content for the requested path.
  String _getContent(String path) {
    if (path == '/index.html') {
      return hostedBlog.getFrontPage();
    } else if (path.endsWith('.json')) {
      return hostedBlog.getJSONFeed();
    } else if (path.endsWith('.xml')) {
      return hostedBlog.getRSSFeed();
    }

    if (path.startsWith('/post')) {
      String idFromUri = path.replaceFirst('/post', '').replaceFirst('.html', '');
      int id = int.parse(idFromUri);
      if (hostedBlog.IDs.indexOf(id) == -1) id = 1;
      return hostedBlog.getBlogPost(id).HTML;
    }

    return '';
  }

  /// Return JSON Feed
  void _serveJsonFile(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.set('Content-Type', 'application/json; charset=utf8')
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers.add('Access-Control-Allow-Methods', 'POST,GET,DELETE,PUT,OPTIONS')
      ..write(hostedBlog.getJSONFeed())
      ..close();
  }

  // Serve an PNG File
  void _servePngFile(HttpRequest request) {
    var imgPng = request.uri.path.toString();
    imgPng = imgPng.replaceFirst('.png', '').replaceFirst('/', '');

    image = hostedBlog.getBlogImage(int.parse(imgPng));
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
      ..headers.set('Content-Type', 'text/html; charset=utf8')
      ..write(robotsTxt)
      ..close();
  }

  // Serve a 404 if an unknow resource is required
  void _serve404(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..headers.set('Content-Type', 'text/html; charset=utf8')
      ..write(page404)
      ..close();
  }

  // processes login form data
  void _performLogin(HttpRequest request) {
    request.listen((List<int> buffer) {
      String page = _checkAdminLogin(buffer);

      request.response
        ..statusCode = HttpStatus.ok
        ..headers.set('Content-Type', 'text/html; charset=utf8')
        ..write(page)
        ..close();
    }, onDone: () => request.response.close());
  }

  // processes post form data
  void _performNewPost(HttpRequest request) {
    request.listen((List<int> buffer) {
      List formData = _getFormData(buffer);
      String newID = hostedBlog.getNextPostID();
      String fileName = '$newID.txt';
      var p = path.join('content', 'posts');
      p = path.join(p, fileName);

      File postFile = File(p);
      String post = BlogPost.createBlogPost(formData[0], formData[1]);
      postFile.writeAsStringSync(post);

      hostedBlog.initBlog();

      request.response
        ..statusCode = HttpStatus.ok
        ..headers.set('Content-Type', 'text/html; charset=utf8')
        ..redirect(Uri(path: 'post$newID.html'))
        ..close();
    });
  }

  // get data from form
  List _getFormData(List<int> buffer) {
    var encodedData = String.fromCharCodes(buffer);
    List pieces = encodedData.split('&');
    List data = [];
    List finalData = [];

    pieces.forEach((dateitem) => data.add(dateitem.substring(dateitem.indexOf('=') + 1)));

    data.forEach((encodedItem) => finalData.add(Uri.decodeQueryComponent(encodedItem)));

    return finalData;
  }

  // check admin data
  // admin:Password1
  String _checkAdminLogin(List<int> buffer) {
    var sha = new Hmac(sha256, buffer); //SHA256();
    String page = '';
    String hex = sha.convert(buffer).toString();

    if (hex != expectedHash) {
      page = wrongPassword;
    } else {
      page = addForm;
    }

    return page;
  }
}
