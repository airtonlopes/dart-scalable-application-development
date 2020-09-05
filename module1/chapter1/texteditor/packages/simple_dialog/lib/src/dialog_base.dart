part of simple_dialog;

/// Simple general purpose div based Dialog box.
class Dialog {
  String dTitle, dBody = '';
  int dWidth, dHeight = 0;
  bool okButton, cancelButton = false;

  String result = '';

  bool _visible = false;
  bool get visible => _visible;

  Function resulthandler;

  DivElement dialogBox = DivElement();
  DivElement contentDiv = DivElement();

  ButtonElement OKButtonUI;

  /// construtor com parâmetros nomeados
  Dialog({
    this.dTitle,
    this.dBody,
    this.dWidth,
    this.dHeight,
    this.okButton = true,
    this.cancelButton = true,
  }) {
    Element title = SpanElement();
    if (dTitle.isNotEmpty) {
      title = DivElement();
      title
        ..text = dTitle
        ..classes.toggle('dialogboxtitle')
        ..style.width = '${dWidth}px';
    }

    contentDiv
      ..text = dBody
      ..style.padding = '5px'
      ..style.width = '${dWidth}px';

    var buttons = DivElement();
    buttons..append(BRElement())..append(BRElement());
    buttons
      ..style.textAlign = 'center'
      ..style.width = '${dWidth}px';

    if (okButton) {
      OKButtonUI = makeButton('OK', setOkStatus);
      buttons.append(OKButtonUI);
    }

    if (cancelButton) {
      var gap = SpanElement();
      gap.appendHtml('&nbsp;&nbsp;&nbsp;');
      buttons.append(gap);
      buttons.append(makeButton('CANCEL', hide));
    }

    dialogBox
      ..style.width = '${dWidth}px'
      ..style.height = '${dHeight}px'
      ..classes.toggle('dialogbox')
      ..append(title)
      ..append(contentDiv)
      ..append(buttons);

    // Add the dialog to the DOM
    document.body.append(dialogBox);
  }

  /// Put the dialog on the screen
  String show([Function handle]) {
    resulthandler = handle;
    _visible = true;
    dialogBox.style.visibility = 'visible';
    return result;
  }

  /// Remove the dialog from the screen
  void hide(MouseEvent me) {
    dialogBox.style.visibility = 'hidden';
  }

  /// Create a button with the supplied text and connect to handler.
  ButtonElement makeButton(String text, [Function clickHandle]) {
    var b = ButtonElement();
    b
      ..text = text
      ..style.width = '100px'
      ..style.padding = '5px';
    if (clickHandle != null) b.onClick.listen(clickHandle);
    return b;
  }

  /// Return ok status and call result handler if set.
  void setOkStatus(MouseEvent me) {
    result = 'ok';
    hide(null);
    if (resulthandler != null) resulthandler(result);
  }
}
