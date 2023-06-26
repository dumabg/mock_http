import 'dart:io';

class MockHttpHeaders implements HttpHeaders {
  final Map<String, String> headers = {};

  MockHttpHeaders(Map<String, String>? headers) {
    if (headers != null) {
      this.headers.addAll(headers);
    }
  }

  @override
  List<String>? operator [](String name) => null;

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    headers[name] = value.toString();
    // List<String>? values = headers[name];
    // if (values == null) {
    //   headers[name] = [value.toString()];
    // } else {
    //   values.add(value.toString());
    // }
  }

  @override
  void clear() => headers.clear();

  @override
  void forEach(void Function(String name, List<String> values) action) {
    // headers.forEach(action);
    headers.forEach((key, value) {
      action.call(key, [value]);
    });
  }

  @override
  void noFolding(String name) {}

  @override
  void remove(String name, Object value) {
    // final  List<String>? values = headers[name];
    // if (values != null) {
    //   values.remove(value);
    // }
    headers.remove(name);
  }

  @override
  void removeAll(String name) {
    headers.remove(name);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    // headers[name] = [value.toString()];
    headers[name] = value.toString();
  }

  @override
  String? value(String name) {
    // final List<String>? values = headers[name];
    // return values?.first;
    return headers[name];
  }

  @override
  bool chunkedTransferEncoding = false;

  @override
  int contentLength = -1;

  @override
  ContentType? contentType;

  @override
  DateTime? date;

  @override
  DateTime? expires;

  @override
  String? host;

  @override
  DateTime? ifModifiedSince;

  @override
  bool persistentConnection = true;

  @override
  int? port;
}
