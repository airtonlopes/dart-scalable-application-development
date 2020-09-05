/// Class generator
import 'dart:html';
import 'dart:math';
import 'package:simple_dialog/simple_dialog.dart';
import 'source_scan.dart';

const String punctuation = ',.-!"';

/// Word Frequency Dialog
class WordFregDialog extends Dialog {
  WordFregDialog({String titleText, String txt})
      : super(
          dTitle: titleText,
          dBody: '',
          dWidth: 400,
          dHeight: 390,
          okButton: true,
          cancelButton: false,
        ) {
    countFrequency(txt);
  }

  void countFrequency(String text) {
    var wordFreqCouts = <String, int>{};
    var out = '';

    for (var character in punctuation.split('')) {
      text = text.replaceAll(character, ' ');
    }
    text = text.toLowerCase();

    var words = text.split(' ');
    words
      ..removeWhere((word) => word == ' ')
      ..removeWhere((word) => word.isEmpty)
      ..forEach((word) {
        if (wordFreqCouts.containsKey(word)) {
          wordFreqCouts[word] = wordFreqCouts[word] + 1;
        } else {
          wordFreqCouts[word] = 1;
        }
      });

    wordFreqCouts.forEach((k, v) => out += ('<tr><td>$k</td><td>$v</td></tr>'));
    contentDiv
      ..appendHtml('<table align="center">$out</table>')
      ..style.height = '290px'
      ..style.width = '380px'
      ..style.overflowY = 'scroll';
  }
}

/// Class Generator Dialog
class GenClassDialog extends Dialog {
  TextInputElement name;
  TextAreaElement fields;
  TextAreaElement methods;

  GenClassDialog()
      : super(
          dTitle: 'Dart Class Generator',
          dBody: '',
          dWidth: 400,
          dHeight: 375,
        ) {
    name = TextInputElement();
    name
      ..placeholder = 'Name'
      ..style.width = '90%';

    fields = TextAreaElement();
    fields
      ..rows = 6
      ..placeholder = 'Fields (new line after each)'
      ..style.resize = 'none'
      ..style.width = '90%';

    methods = TextAreaElement();
    methods
      ..rows = 6
      ..placeholder = 'Methods (new line after each)'
      ..style.resize = 'none'
      ..style.width = '90%';

    contentDiv
      ..append(name)
      ..append(BRElement())
      ..append(BRElement())
      ..append(fields)
      ..append(BRElement()).append(BRElement())
      ..append(methods)
      ..style.display = '';
  }

  // Set ok status and call result handler if set
  @override
  void setOkStatus(MouseEvent me) {
    hide(null);
    makeClass();
    resulthandler('ok');
  }

  // Create the actual source code from the Use input.
  void makeClass() {
    var className = name.value;
    var fieldsSrc = '';
    var methodsSrc = '';

    var classFields = fields.value.split('\n');
    var classMethods = methods.value.split('\n');

    classFields.forEach((field) => fieldsSrc += ' var $field;\n');
    classMethods.forEach((method) => methodsSrc += ' $method(){};\n');

    result = ''' /// The $className class.
    class $className {
      $fieldsSrc

      $className(){}

      $methodsSrc
    }
    ''';
  }
}

/// Source Code Status Dialog
class CodeStatsDialog extends Dialog {
  CanvasRenderingContext2D context2d;

  CodeStatsDialog()
      : super(
          dTitle: 'Source Status',
          dWidth: 510,
          dHeight: 400,
          okButton: true,
          cancelButton: false,
        ) {
    var name = TextInputElement();
    name.placeholder = 'Fields';

    var methods = TextAreaElement();
    methods.placeholder = 'Methods';

    var graphs = CanvasElement();
    graphs.width = 500;
    graphs.height = 270;
    context2d = graphs.getContext('2d');
    contentDiv..append(BRElement())..append(graphs);
  }

  void scanCode(String srcCode) {
    // Get the stats.
    var data = [0.0, 0.0, 0.0, 0.0];
    var totalLines = 0.0;
    var scanner = SourceCodeScanner();

    scanner.scan(srcCode.split('\n'));
    data[0] = (scanner.totalLines - (scanner.comments + scanner.whiteSpace + scanner.imports)).roundToDouble();
    data[1] = scanner.comments.roundToDouble();
    data[2] = scanner.imports.roundToDouble();
    data[3] = scanner.whiteSpace.roundToDouble();
    totalLines = scanner.totalLines.roundToDouble();

    // Display Pie chart
    var lastpos = 0.0;
    var labels = ['Code', 'Comments', 'Imports', 'Whitespace'];
    var colors = ['red', 'green', 'blue', 'yellow'];
    var radius = 130;

    for (var i = 0; i < 4; i++) {
      context2d
        ..fillStyle = colors[i]
        ..strokeStyle = 'black'
        ..beginPath()
        ..moveTo(radius, radius)
        ..arc(radius, radius, radius, lastpos, (lastpos + (pi * 2.0 * (data[i] / totalLines))), false)
        ..lineTo(radius, radius)
        ..fill()
        ..stroke()
        ..closePath();

      lastpos += pi * 2.0 * (data[i] / totalLines);
      print(lastpos);

      context2d
        ..beginPath()
        ..strokeStyle = 'black'
        ..fillStyle = colors[i]
        ..fillRect(380, 90 + 20 * i, 8, 8)
        ..strokeRect(380, 90 + 20 * i, 8, 8)
        ..strokeText(labels[i], 400, 100 + 20 * i)
        ..stroke()
        ..closePath();
    }
  }
}
