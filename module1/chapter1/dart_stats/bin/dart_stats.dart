// import 'package:dart_stats/dart_stats.dart' as dart_stats;
import 'package:dart_stats/sourcescan.dart';
import 'dart:io';

void main(List<String> arguments) {
  // print('Hello world: ${dart_stats.calculate()}!');
  print(arguments[0]);
  var codeScan = SourceCodeScanner();
  var myFile = File(arguments[0]);

  void scan(List<String> lines) {
    codeScan.scan(lines);
    print('${codeScan.totalLines}');
    print('${codeScan.classes}');
    print('${codeScan.comments}');
    print('${codeScan.imports}');
    print('${codeScan.whitespace}');
  }

  myFile.readAsLines().then(scan);
}
