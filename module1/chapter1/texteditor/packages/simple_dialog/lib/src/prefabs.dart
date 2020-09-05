part of simple_dialog;

/// Equivalent of JS confirm - Ok Cancel buttons.
void confirm({String title, String prompt, int width, int height, Function action}) {
  var dialog = Dialog(
    dTitle: title,
    dBody: prompt,
    dWidth: width,
    dHeight: height,
  );
  dialog.show(action);
}

/// Equivalent of JS alert - Ok button.
void alert({String title, String prompt, int width, int height}) {
  var dialog = Dialog(
    dTitle: title,
    dBody: prompt,
    dWidth: width,
    dHeight: height,
    okButton: true,
    cancelButton: false,
  );
  dialog.show();
}

/// About box - text content with hyperlink
class AboutDialog extends Dialog {
  final String linkUrl;
  final String linkText;

  AboutDialog({
    String title,
    String text,
    this.linkUrl,
    this.linkText,
    int width,
    int height,
  }) : super(
          dTitle: title,
          dBody: text,
          dWidth: width,
          dHeight: height,
          okButton: true,
          cancelButton: false,
        ) {
    // Customise the content for a about box.
    var link = AnchorElement();
    link.href = linkUrl;
    link.text = linkText;
    link.setAttribute('target', '_blank');
    contentDiv
      ..nodes.insert(0, BRElement())
      ..nodes.insert(0, BRElement())
      ..append(BRElement())
      ..append(BRElement())
      ..append(link)
      ..style.textAlign = 'center';
  }
}
