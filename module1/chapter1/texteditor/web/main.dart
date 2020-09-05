import 'dart:html';
import 'dart:async';
import 'editor.dart';
import 'package:intl/intl.dart';

//
TextEditor theEditor;

//
Element id(String name) => querySelector('#$name');

//
Element tool(String idName, Function callback) {
  var el = id(idName);
  el.onClick.listen(callback);
  return el;
}

void main() {
  // Set up the Editor.
  theEditor = TextEditor(id('editor'));

  // Connect Toolbar items to the Editor methods.
  /*var btnClear = */ tool('btnClearText', theEditor.clearEditor);
  /*var btnDownload = */ tool('btnDownload', theEditor.downloadFile);
  /*var btnAbout = */ tool('btnAbout', theEditor.showAbout);
  /*var btnClassGen = */ tool('btnClassGen', theEditor.showClassGen);
  /*var btnWordCount = */ tool('btnWordCount', theEditor.showWordCount);
  /*var btnFreq = */ tool('btnFreq', theEditor.showFreqCount);
  /*var btnStat = */ tool('btnCodeStats', theEditor.showStats);

  // Clock
  Timer.periodic(Duration(seconds: 1), (timer) => id('clock').text = (DateFormat('HH:mm:ss')).format(DateTime.now()));
}
