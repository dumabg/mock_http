import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'mock_http_client_request_data.dart';
import 'mock_http_client_response.dart';
import 'mock_http_headers.dart';

class MockEncoding extends Encoding {
  @override
  Converter<List<int>, String> get decoder => throw UnimplementedError();

  @override
  Converter<String, List<int>> get encoder => throw UnimplementedError();

  @override
  String get name => throw UnimplementedError();
}

class MockHttpClientRequest extends HttpClientRequest {
  final Response Function(MockHttpClientRequestData) fCallResponse;
  final HttpHeaders _headers;
  Encoding _encoding;
  final List<int> _data = [];
  List<int> get data => _data;

  MockHttpClientRequest(
      {required this.fCallResponse,
      Map<String, String>? headers,
      Encoding? encoding})
      : _headers = MockHttpHeaders(headers),
        _encoding = encoding ?? MockEncoding();

  @override
  Future<HttpClientResponse> get done async {
    Response response =
        fCallResponse.call(MockHttpClientRequestData(_data, _headers));
    return Future.value(MockHttpClientResponse(
        MockHttpHeaders(response.headers),
        response.statusCode,
        response.bodyBytes));
  }

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}

  @override
  void add(List<int> data) {
    _data.addAll(data);
  }

  @override
  // ignore: no-empty-block
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future addStream(Stream<List<int>> stream) async {
    await for (final List<int> value in stream) {
      _data.addAll(value);
    }
  }

  @override
  Future<HttpClientResponse> close() {
    return done;
  }

  @override
  HttpConnectionInfo? get connectionInfo => null;

  @override
  List<Cookie> get cookies => [];

  @override
  Future flush() {
    return Future<void>.value();
  }

  @override
  HttpHeaders get headers => _headers;

  @override
  String get method => '';

  @override
  Uri get uri => Uri();

  @override
  void write(Object? object) {
    add(object.toString().codeUnits);
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    for (final object in objects) {
      write(object);
      if (separator.isNotEmpty) {
        write(separator);
      }
    }
  }

  @override
  void writeCharCode(int charCode) {
    write(String.fromCharCode(charCode));
  }

  @override
  void writeln([Object? object = '']) {
    write(object);
    write('\n');
  }

  @override
  Encoding get encoding => _encoding;
  @override
  set encoding(Encoding value) => _encoding = value;
}
