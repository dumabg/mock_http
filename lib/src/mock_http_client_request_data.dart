import 'dart:io';

class MockHttpClientRequestData {
  final List<int> data;
  final HttpHeaders headers;

  MockHttpClientRequestData(this.data, this.headers);

  String dataToString() {
    return String.fromCharCodes(data);
  }
}
