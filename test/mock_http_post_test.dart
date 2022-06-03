import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mock_http/mock_http.dart';
import 'package:test/test.dart';

void main() {
  group('Mock POST https://www.google.com', () {
    var mockHttp =
        MockHttp(defaultScheme: 'https', defaultHost: 'www.google.com');

    setUp(() {
      HttpOverrides.global = mockHttp;
    });

    test('POST', () async {
      mockHttp.registerPosts(pathResponses: {
        '': (_) => http.Response('POST done', HttpStatus.ok),
      });
      http.Response response =
          await http.post(Uri(scheme: 'https', host: 'www.google.com'));
      expect(response.body, 'POST done');
      expect(response.statusCode, HttpStatus.ok);
    });

    test('POST with body', () async {
      mockHttp.registerPosts(pathResponses: {
        '/hola': (MockHttpClientRequestData value) => http.Response(
            'POST done with ${value.dataToString()}', HttpStatus.ok),
      });
      http.Response response = await http.post(
          Uri(scheme: 'https', host: 'www.google.com', path: '/hola'),
          body: 'Hola');
      expect(response.body, 'POST done with Hola');
      expect(response.statusCode, HttpStatus.ok);
    });
  });
}
