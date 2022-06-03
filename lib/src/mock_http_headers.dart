import 'dart:io';

class MockHttpHeaders extends HttpHeaders {
  final Map<String, String> headers = {};

  MockHttpHeaders(Map<String, String>? headers) {
    if (headers != null) {
      this.headers.addAll(headers);
    }
  }

  @override
  List<String>? operator [](String name) => null;

  @override
  // ignore: no-empty-block
  void add(String name, Object value, {bool preserveHeaderCase = false}) =>
      headers[name] = value.toString();

  @override
  // ignore: no-empty-block
  void clear() => headers.clear();

  @override
  // ignore: no-empty-block
  void forEach(void Function(String name, List<String> values) action) {}

  @override
  // ignore: no-empty-block
  void noFolding(String name) {}

  @override
  // ignore: no-empty-block
  void remove(String name, Object value) {}

  @override
  // ignore: no-empty-block
  void removeAll(String name) {}

  @override
  // ignore: no-empty-block
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  String? value(String name) => headers[name];
}
