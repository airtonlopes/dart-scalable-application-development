import 'dart:io';

void main() {
  print('Starting...');

  var uri = 'http://127.0.0.1:8080/index.html';
  var hc = HttpClient();
  var watch = Stopwatch();
  var attemptedRequests = 1000;
  var ms = 0;

  print('Starting testing...');
  watch.start();

  for (var i = 0; i < attemptedRequests; i++) {
    hc.getUrl(Uri.parse(uri)).then((HttpClientRequest request) => request.close()).then((HttpClientResponse response) {
      if (response.statusCode == HttpStatus.ok) {
        ms += watch.elapsed.inMilliseconds;
        print('$i, ${response.statusCode}, ${watch.elapsed.inMilliseconds}, ${(ms / 100).toStringAsFixed(2)}');
      }
    });
  }
}
