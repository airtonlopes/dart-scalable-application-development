import 'dart:mirrors';

class Temporary {
  final String removalBuildLabel;
  const Temporary(this.removalBuildLabel);

  // String toString() => removalBuildLabel;
}

@Temporary('Build1')
class TempWidgetTxt {}

@Temporary('build2')
class TempWidgetWithGFX {}

void main() {
  var classMirror1 = reflectClass(TempWidgetTxt);
  var classMirror2 = reflectClass(TempWidgetWithGFX);

  var metadata1 = classMirror1.metadata;
  print(metadata1.first.reflectee);

  var metadata2 = classMirror2.metadata;
  print(metadata2.first.reflectee);
}
