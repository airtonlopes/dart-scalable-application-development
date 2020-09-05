import 'dart:html';
import 'package:intl/intl.dart';
import 'package:presenter/messages_all.dart';

/// Class to hold all the translatable strings.
class PhraseBook {
  // Navigation controls
  static String btnFirstSlide() => Intl.message('First', name: 'btnFirstSlide', desc: 'Button label - go to the first slide.');
  //
  static String btnPrevSlide() => Intl.message('Prev', name: 'btnPrevSlide', desc: 'Button label - go to the previous slide.');
  //
  static String btnNextSlide() => Intl.message('Next', name: 'btnNextSlide', desc: 'Button label - go to the next slide.');
  //
  static String btnLastSlide() => Intl.message('Last', name: 'btnLastSlide', desc: 'Button label - go to the last slide.');

  // Tools.
  static String btnInsertDate() => Intl.message('Insert', name: 'btnInsertDate', desc: 'Button label - insert the current date to the presentation');
  //
  static String btnTimer() => Intl.message('Start/Stop', name: 'btnTimer', desc: 'Button label - Start and Stop the pratice timer.');
  //
  static String btnDemo() => Intl.message('Demo', name: 'btnDemo', desc: 'Button label - Insert the demo presentation script into the editor.');
  //
  static String btnOverview() => Intl.message('Overview', name: 'btnOverview', desc: 'Button label - Show the overview screen');
  //
  static String btnHandouts() => Intl.message('Handout', name: 'btnHandouts', desc: 'Button label - Show the handout screen');
  //
  static String lblPageColor() => Intl.message('Page Background', name: 'lblPageColor', desc: 'Color picker label - page background color');
  //
  static String btnStartShow() => Intl.message('Start Show', name: 'btnStartShow', desc: 'Button label - Start the show');
  //
  static String btnEndShow() => Intl.message('End Show', name: 'btnEndShow', desc: 'Button label - End the show.');
}

//
Element setCtrlText(String id, [String value]) {
  var el = querySelector('#$id');
  if (value != null) {
    el.setAttribute('value', value);
  }
  return el;
}

// Set the interfaces elements to the translated text.
void addInterfaceText() {
  // Navigation controls
  setCtrlText('btnFirst', PhraseBook.btnFirstSlide());
  setCtrlText('btnPrev', PhraseBook.btnPrevSlide());
  setCtrlText('btnNext', PhraseBook.btnNextSlide());
  setCtrlText('btnLast', PhraseBook.btnLastSlide());

  // Tools.
  setCtrlText('btnInsertDate', PhraseBook.btnInsertDate());
  setCtrlText('btnTimer', PhraseBook.btnTimer());

  // Misc
  setCtrlText('btnDemo', PhraseBook.btnDemo());
  setCtrlText('btnOverview', PhraseBook.btnOverview());
  setCtrlText('btnHandouts', PhraseBook.btnHandouts());
  setCtrlText('lblPageColor').text = PhraseBook.lblPageColor();

  // Show control.
  setCtrlText('btnStartShow', PhraseBook.btnStartShow());
  setCtrlText('btnEndShow', PhraseBook.btnEndShow());
}

/// Set the interface to a particular language.
void setInterfaceLang(String langID) {
  initializeMessages(langID).then((_) {
    Intl.defaultLocale = langID;
    addInterfaceText();
  });
}
