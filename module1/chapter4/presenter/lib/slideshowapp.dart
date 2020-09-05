library slideshowapp;

import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:presenter/slideshow.dart';
import 'package:presenter/sampleshows.dart';
import 'package:presenter/interfacestrans.dart';

/// Slide Show Application for giving presentations
class SlideShowApp {
  // Slideshow data.
  int currentSlideIndex = 0;
  int liveSlideID = 0;
  int liveSlideY = 0;
  bool isFullScreen = false;
  SlideShow currentSlideShow = SlideShow();

  // Timer
  Stopwatch slidesTime = Stopwatch();
  Timer updateTimer;

  // Editor controls.
  SpanElement timerDisplay;
  DivElement slideScreen;
  DivElement overviewScreen;
  TextAreaElement presEditor;
  RangeInputElement rangeSlidePos;

  // Full screen display
  DivElement liveFullScreen;
  DivElement liveSlide;

  // Audio
  AudioElement slideChange;

  // Function shortcut.
  Function qs = querySelector;

  // Local.
  String langInterface = 'en';

  // Date Formatter
  DateFormat slideDateFormatter;

  // Constructor for the core Slideshow presentation application
  SlideShowApp() {
    setButton('#btnDemo', buildDemo);
    setButton('#btnFirst', startSlideShow);
    setButton('#btnLast', lastSlideShow);
    setButton('#btnPrev', backSlideShow);
    setButton('#btnNext', nextSlide);
    setButton('#btnTimer', toggleTimer);

    // var controls = qs('#controls');
    presEditor = qs('#presentation');

    // Slide navigation via range control
    rangeSlidePos = qs('#rngSlides');
    rangeSlidePos.onChange.listen(moveToSlide);

    // Insert Date Into Presentation
    var btnInsertDate = qs('#btnInsertDate');
    btnInsertDate.onClick.listen(insertDate);

    // Display an overview
    setButton('#btnOverview', showOverview);

    // Printable handout sheet
    setButton('#btnHandouts', showHandout);

    // Get referece to the main slide display
    slideScreen = qs('#slides');

    // Get reference to the timer display
    timerDisplay = qs('#timerDisplay');

    // Set the overview to hide when clicked
    overviewScreen = DivElement();
    overviewScreen.classes.toggle('fullScreen');
    overviewScreen.onClick.listen((e) => overviewScreen.remove());

    // Update the presentation on change
    presEditor.onKeyUp.listen(updatePresentation);

    // Full screen presentation
    setupFullScreen();

    // Keyboard navigation
    setupKeyboardNavigation();

    // Allow the color of the page to be set
    var cp = qs('#pckBackColor');
    cp.onChange.listen((e) => document.body.style.backgroundColor = cp.value);

    // Animation timer.
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (isFullScreen && liveSlideY < 0) {
        liveSlide.style.top = liveSlideY.toString() + 'px';
        liveSlideY += 50;
      }
    });

    // Set the interface locacle.
    setInterfaceLang('en');
    qs('#interfaceLang').onChange.listen((e) {
      var lang = qs('#interfaceLang').value;
      setInterfaceLang(lang);
      langInterface = lang;
      initDefaultDate();
    });

    langInterface = 'en';

    // Load up the sound for changing slides
    loadAudio();

    // Set up the date.
    initDefaultDate();
  }

  // Set the date according to the local
  void initDefaultDate() {
    initializeDateFormatting(langInterface, null).then((e) {
      slideDateFormatter = DateFormat.yMMMMEEEEd(langInterface);
    });
  }

  //
  void setupKeyboardNavigation() {
    // Keyboard navigation.
    window.onKeyUp.listen((KeyboardEvent e) {
      if (isFullScreen) {
        if (e.keyCode == 39) {
          liveSlideID++;
          updateLiveSlide();
        } else if (e.keyCode == 37) {
          liveSlideID--;
          updateLiveSlide();
        }
      } else {
        // Check the editor does not have focus.
        if (presEditor != document.activeElement) {
          if (e.keyCode == 39) {
            showNextSlide();
          } else if (e.keyCode == 37) {
            showPrevSlide();
          } else if (e.keyCode == 38) {
            showFirstSlide();
          } else if (e.keyCode == 40) {
            showLastSlide();
          }
        }
      }
    });

    //
    window.onKeyUp.listen((KeyboardEvent e) {
      // Check the editor does not have focus
      if (presEditor != document.activeElement) {
        DivElement helpBox = qs('#helpKeyboardShortcuts');
        if (e.keyCode == 191) {
          if (helpBox.style.visibility == 'visible') {
            helpBox.style.visibility = 'hidden';
          } else {
            helpBox.style.visibility = 'visible';
          }
        }
      }
    });
  }

  //
  void setupFullScreen() {
    // Full screen presentation
    liveFullScreen = qs('#presentationSlideshow');
    liveFullScreen.onClick.listen((e) {
      liveSlideID++;
      updateLiveSlide();
    });

    // Start the show button.
    qs('#btnStartShow').onClick.listen((e) {
      isFullScreen = true;
      liveFullScreen
        ..requestFullscreen()
        ..focus()
        ..classes.toggle('fullScreenShow')
        ..style.visibility = 'visible';

      liveSlideID = 0;
      updateLiveSlide();
    });

    // Manual button to exit full screen
    qs('#btnEndShow').onClick.listen((e) {
      isFullScreen = false;
      liveFullScreen..style.visibility = 'hidden';
      liveSlide.style.visibility = 'hidden';
    });

    liveFullScreen.onFullscreenChange.listen((e) {
      if (document.fullscreenEnabled) {
      } else {
        liveFullScreen.style.visibility = 'hidden';
      }
    });
  }

  // Load audio assets
  List<Future> loadAudio() {
    slideChange = AudioElement('snd/slidechange.ogg');
    slideChange.preload = 'auto';
    return [slideChange.onLoad.first];
  }

  //
  void playSnd() {
    slideChange
      ..play()
      ..onEnded.listen(done);
  }

  //
  void done(e) {
    slideChange.load();
  }

  // Update the live slide display with the current slide
  void updateLiveSlide() {
    playSnd();

    liveSlideY = -1000;
    liveSlideID = min(max(liveSlideID, 0), currentSlideShow.slides.length - 1);
    liveSlide = currentSlideShow.slides[liveSlideID].getSlideContents();

    liveSlide
      ..classes.toggle('fullScreenSlide')
      ..style.top = liveSlideY.toString() + 'px';

    liveFullScreen
      ..nodes.clear()
      ..nodes.add(liveSlide);
  }

  //
  void setButton(String id, Function clickHandler) {
    ButtonInputElement btn = querySelector(id);
    btn.onClick.listen(clickHandler);
  }

  //
  void buildDemo(MouseEvent event) {
    // Recreate the slideshow
    presEditor.value = demo;

    currentSlideIndex = 0;
    updatePresentation(null);
    updateRangeControl();
  }

  // Update range control.
  void updateRangeControl() {
    rangeSlidePos
      ..min = '0'
      ..max = (currentSlideShow.slides.length - 1).toString();
  }

  // Move to slide specified by (slide)
  void showSlide(int slide) {
    if (currentSlideShow.slides.isEmpty) {
      return;
    }

    slideScreen.style.visibility = 'hidden';
    slideScreen
      ..nodes.clear()
      ..nodes.add(currentSlideShow.slides[slide].getSlideContents());

    rangeSlidePos.value = slide.toString();
    slideScreen.style.visibility = 'visible';
  }

  // Move to the next slide
  void nextSlide(MouseEvent event) {
    showNextSlide();
  }

  //
  void showNextSlide() {
    currentSlideIndex = min(currentSlideShow.slides.length - 1, ++currentSlideIndex);
    showSlide(currentSlideIndex);
  }

  // Move to the previous slide
  void backSlideShow(MouseEvent event) {
    showPrevSlide();
  }

  //
  void showPrevSlide() {
    currentSlideIndex = max(0, --currentSlideIndex);
    showSlide(currentSlideIndex);
  }

  // Move to the first slide
  void startSlideShow(MouseEvent event) {
    showFirstSlide();
  }

  //
  void showFirstSlide() {
    showSlide(0);
  }

  // Move to the last slide
  void lastSlideShow(MouseEvent event) {
    showLastSlide();
  }

  //
  void showLastSlide() {
    currentSlideIndex = max(0, currentSlideShow.slides.length - 1);
    showSlide(currentSlideIndex);
  }

  // Move to the slide that the range control indicates.
  void moveToSlide(Event event) {
    currentSlideIndex = int.parse(rangeSlidePos.value);
    showSlide(currentSlideIndex);
  }

  // Append the date to the end of the presentation source.
  void insertDate(Event event) {
    DateInputElement datePicker = qs('#selDate');

    var processDate = slideDateFormatter.format(datePicker.valueAsDate);
    if (datePicker.valueAsDate != null) {
      presEditor.value = presEditor.value + processDate.toString();
    }
  }

  // Show the overview version of the display
  void showOverview(Event event) {
    buildOverview();
  }

  // Show the handout version of the display
  void showHandout(Event event) {
    buildOverview(true);
  }

  // Build the overview Div element
  void buildOverview([bool addNotes = false]) {
    if (currentSlideShow.slides.isEmpty) {
      return;
    }

    DivElement aSlide;
    DivElement slideBackground;

    // Reset and add a gap
    overviewScreen.nodes
      ..clear()
      ..add(BRElement())
      ..add(BRElement())
      ..add(BRElement())
      ..add(BRElement());

    // Build a overview version of slideshow
    currentSlideShow.slides.forEach((s) {
      aSlide = s.getSlideContents();
      aSlide.classes.toggle('slideOverview');
      aSlide.classes.toggle('shrink');

      slideBackground = DivElement();
      slideBackground.classes.toggle('slideBackground');
      slideBackground.nodes.add(aSlide);

      if (addNotes) {
        var notes = DivElement();
        notes.classes.toggle('slideNotes');
        notes.text = 'Notes';
        slideBackground.nodes.add(notes);
        aSlide.style.marginLeft = '0%';
      }

      overviewScreen.nodes.add(slideBackground);

      if (!addNotes) {
        overviewScreen.nodes..add(BRElement())..add(BRElement());
      }
    });

    // Add a gap
    overviewScreen.nodes..add(BRElement())..add(BRElement())..add(BRElement())..add(BRElement());

    document.body.nodes.add(overviewScreen);
  }

  // Update the presetation datastructure based on the TextArea source.
  void updatePresentation(Event event) {
    currentSlideShow = SlideShow();
    currentSlideShow.build(presEditor.value);

    updateRangeControl();
    showSlide(currentSlideIndex);
  }

  // Start or stop the timer
  void toggleTimer(Event event) {
    if (slidesTime.isRunning) {
      slidesTime.stop();
      updateTimer.cancel();
    } else {
      updateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        var seconds = (slidesTime.elapsed.inSeconds % 60).toString();
        seconds = seconds.padLeft(2, '0');
        timerDisplay.text = '${slidesTime.elapsed.inMinutes}:$seconds';
      });

      slidesTime
        ..reset()
        ..start();
    }
  }
}
