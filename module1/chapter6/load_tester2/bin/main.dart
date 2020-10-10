import 'dart:io';

void main() async {
  print('Starting...');

  var url = 'http://localhost:3000/index.html';
  var hc = HttpClient();
  var watch = Stopwatch();
  var attemptedRequests = 200;

  print('Starting testing...');
  watch.start();

  for (var i = 0; i < attemptedRequests; i++) {
    await callWebPage(hc, url, i, watch);
  }
}

Future<void> callWebPage(HttpClient client, String targetUrl, int requestNumber, Stopwatch watch) async {
  HttpClientRequest request;
  HttpClientResponse response;
  request = await client.getUrl(Uri.parse(targetUrl));
  response = await request.close();
  print('$requestNumber, ${response.statusCode}, ${watch.elapsed.inMilliseconds}');
}
