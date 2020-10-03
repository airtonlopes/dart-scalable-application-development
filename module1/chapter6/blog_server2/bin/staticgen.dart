library staticgen;

import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:blog_server/blog.dart';

main() async {
  var contPath = path.join(Directory.current.path, 'content');
  var srcPath = path.join(contPath, 'posts');
  var imgPath = path.join(contPath, 'img');

  Blog staticBlog = Blog(srcPath, imgPath);
  await staticBlog.initBlog();
  print(Directory.current);

  // Create output directory if it does not exists.
  var outDir = Directory('staticoutput');
  var staticPath = path.join(Directory.current.path, 'staticoutput');
  if (!await outDir.exists()) {
    outDir.create();
  }

  // Write out main page.
  var outPath = path.join(staticPath, 'index.html');
  var pageContent = staticBlog.getFrontPage();
  File indexPage = File(outPath);
  await indexPage.writeAsStringSync(pageContent, mode: FileMode.append);

  // Return success exit code
  exit(0);
}
