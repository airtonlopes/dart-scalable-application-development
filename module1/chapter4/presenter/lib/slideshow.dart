library slideshowobjects;

import 'dart:html';
import 'package:presenter/lifecyclemixin.dart';

/// A class to hand Slides and their display.
class Slide extends Object with LifecycleTracker {
  String titleText = '';
  List<String> bulletPoints;
  String imageUrl = '';

  // Constructor for the slide
  Slide(this.titleText) {
    bulletPoints = <String>[];
    createTimestamp();
  }

  // Returns div element for this slide contents.
  DivElement getSlideContents() {
    var slide = DivElement();
    var title = DivElement();
    var bullets = DivElement();

    title.appendHtml('<h1>$titleText</h1>');
    slide.append(title);

    if (imageUrl.isNotEmpty) {
      slide.appendHtml('<img src="$imageUrl" /><br>');
    }

    bulletPoints.forEach((bp) {
      if (bp.trim().isNotEmpty) {
        bullets.appendHtml('<li>$bp</li>');
      }
    });

    slide.append(bullets);

    return slide;
  }
}

/// A class to hand a set of Slides in a presentation
class SlideShow extends Object with LifecycleTracker {
  List<Slide> _slides;

  List<Slide> get slides => _slides;

  // Constructor fot the slideshow
  SlideShow() {
    _slides = <Slide>[];
    createTimestamp();
  }

  // Build a slideshow from the supplied [src] Markdown
  void build(String src) {
    updateTimestamp();
    _slides = <Slide>[];
    Slide nextSlide;

    src.split('\n').forEach((String line) {
      if (line.trim().isNotEmpty) {
        //
        var lineValue = line.substring(1);

        // Title - also marks start of the next slide.
        if (line.startsWith('#')) {
          nextSlide = Slide(lineValue);
          _slides.add(nextSlide);
        }

        if (nextSlide != null) {
          if (line.startsWith('+')) {
            nextSlide.bulletPoints.add(lineValue);
          } else if (line.startsWith('!')) {
            nextSlide.imageUrl = lineValue;
          }
        }
      }
    });
  }
}
