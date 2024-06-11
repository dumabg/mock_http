import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mock_http/mock_http.dart';

void main() {
  group('Mock POST https://www.google.com', () {
    final mockHttp =
        MockHttp(defaultScheme: 'https', defaultHost: 'www.google.com');

    setUp(() {
      HttpOverrides.global = mockHttp;
    });

    test('POST', () async {
      mockHttp.registerPosts(pathResponses: {
        '/hola': (MockHttpClientRequestData request) {
          print(request.data);
          return http.Response('POST done', HttpStatus.ok);
        },
      });
      final http.Response response = await http.post(
          Uri(scheme: 'https', host: 'www.google.com', path: '/hola'),
          body: 'Hola');
      expect(response.body, 'POST done');
      expect(response.statusCode, HttpStatus.ok);
    });
  });
}
