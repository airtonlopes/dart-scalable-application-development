library log;

import 'dart:io';

/// Write an entry to the web access log
void log(HttpRequest request) {
  String entry = getLogEntry(request);
  File logstore = File('access.log');
  logstore.writeAsStringSync(entry, mode: FileMode.append);
}

/// Generate a string of meta-information based on the request.
String getLogEntry(HttpRequest request) {
  // USER_AGENT
  HttpHeaders headers = request.headers;
  String reqUri = '${request.uri.path}';
  String address = request.connectionInfo.remoteAddress.address;
  String userAgent = headers[HttpHeaders.userAgentHeader].toString();

  String entry = " $address:${headers.port} $reqUri $userAgent \r\n";
  String access = DateTime.now().toString() + entry;
  return access;
}
