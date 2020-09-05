import 'dart:convert';
import 'dart:html';
import 'package:simple_dialog/simple_dialog.dart';
import 'custom_dialogs.dart';

const KeyNameStorage = 'MyTextEditor';

/// The editor class - handling load/save and utilities.
class TextEditor {
  final String appTitle = 'TextEditor';
  final TextAreaElement theEditor;

  GenClassDialog gcd;

  TextEditor(this.theEditor) {
    theEditor
      ..onKeyUp.listen(handleKeyPress)
      ..value = loadDocument();
  }

  // Event Handlers. -------------
  // @override
  void handleKeyPress(KeyboardEvent event) {
    saveDocument();
  }

  // Event Handlers. -------------
  void clearEditor(MouseEvent event) {
    confirm(
      title: appTitle,
      prompt: 'Are you sure want to clear the text ?',
      width: 400,
      height: 120,
      action: performClear,
    );
  }

  //
  void showAbout(MouseEvent event) {
    var textEditorAbout = AboutDialog(
      title: appTitle,
      text: 'TextEditor for the Web',
      linkUrl: 'https://pub.dev',
      linkText: 'Homepage',
      width: 300,
      height: 200,
    );
    textEditorAbout.show();
  }

  //
  void showWordCount(MouseEvent event) {
    var txt = theEditor.value;
    for (var c in punctuation.split('')) {
      txt = txt.replaceAll(c, ' ');
    }

    var words = txt.split(' ');
    words..removeWhere((s) => s == '')..removeWhere((s) => s.isEmpty);

    alert(
      title: appTitle,
      prompt: 'Word Count ${words.length}',
      width: 200,
      height: 120,
    );
  }

  //
  void showFreqCount(MouseEvent event) {
    var wfd = WordFregDialog(titleText: appTitle, txt: theEditor.value);
    wfd.show();
  }

  //
  void showClassGen(MouseEvent event) {
    gcd = GenClassDialog();
    gcd.show(createClassCode);
  }

  //
  void showStats(MouseEvent event) {
    var csd = CodeStatsDialog();
    csd.scanCode(theEditor.value);
    csd.show();
  }

  //
  void downloadFile(MouseEvent event) {
    downloadFileToClient('TextEditor.txt', theEditor.value);
  }

  // Actions. -------------
  void performClear(String result) {
    if (result == 'ok') {
      theEditor.value = '';
      window.localStorage[KeyNameStorage] = '';
    }
  }

  //
  String loadDocument() {
    var readings = '';
    var jsonString = window.localStorage[KeyNameStorage];
    if (jsonString != null && jsonString.isNotEmpty) {
      readings = json.decode(jsonString);
    }
    return readings;
  }

  //
  void saveDocument() {
    window.localStorage[KeyNameStorage] = json.encode(theEditor.value);
  }

  //
  void downloadFileToClient(String fileName, String text) {
    var tempLink = document.createElement('a');
    tempLink
      ..attributes['href'] = 'data:text/plain;charset=utf-8,' + Uri.encodeComponent(text)
      ..attributes['download'] = fileName
      ..click();
  }

  //
  void createClassCode(String result) {
    theEditor.value = gcd.result;
  }
}
