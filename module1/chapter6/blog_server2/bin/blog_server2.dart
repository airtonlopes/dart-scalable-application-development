import 'dart:io';

import 'package:path/path.dart' as path;

void main(List<String> arguments) async {
  var myFile = new File('example.txt');
  myFile.writeAsStringSync('Hello World!');

  var dir = Directory(Directory.current.path + '/content/posts');
  print(dir.path);
  var _list = await dir.list();
  await for (File f in _list) {
    print(path.basenameWithoutExtension(f.path));
  }
}
