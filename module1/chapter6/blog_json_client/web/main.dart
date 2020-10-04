import 'dart:html';
import 'dart:convert';

void main() {
  var jsonSrc = 'http://127.0.0.1:3000/feed.json';

  HttpRequest.getString(jsonSrc).then((String data) {
    List decoded = json.decode(data);
    var app = querySelector('#output');
    app.classes.remove('loading');

    decoded.forEach((post) {
      app.children.add(LIElement()
        ..append(AnchorElement()
          ..href = post['url']
          ..text = "${post['date']} ${post['title']}"));
    });
  });
}
