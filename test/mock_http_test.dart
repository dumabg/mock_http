import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mock_http/mock_http.dart';

void main() {
  group('Mock https://www.google.com', () {
    final mockHttp =
        MockHttp(defaultScheme: 'https', defaultHost: 'www.google.com');

    setUp(() {
      HttpOverrides.global = mockHttp;
    });

    test('GET', () async {
      mockHttp.registerGets(pathResponses: {
        '/hola': (_) => http.Response('Hola', HttpStatus.ok),
        '/pepe': (_) => http.Response('Hola Pepe', HttpStatus.ok)
      });

      http.Response response = await http
          .get(Uri(scheme: 'https', host: 'www.google.com', path: '/hola'));
      expect(response.body, 'Hola');
      expect(response.statusCode, HttpStatus.ok);

      response = await http
          .get(Uri(scheme: 'https', host: 'www.google.com', path: '/pepe'));
      expect(response.body, 'Hola Pepe');
      expect(response.statusCode, HttpStatus.ok);

      print(response.body);
      print(response.statusCode);
    });

    test('POST', () async {
      mockHttp.registerPosts(pathResponses: {
        '': (_) => http.Response('POST done', HttpStatus.ok),
      });
      final http.Response response =
          await http.post(Uri(scheme: 'https', host: 'www.google.com'));
      expect(response.body, 'POST done');
      expect(response.statusCode, HttpStatus.ok);
    });
  });

  group('AllowHttpClientWhenNoMock', () {
    final mockHttp =
        MockHttp(defaultScheme: 'https', defaultHost: 'www.google.com');

    setUp(() {
      HttpOverrides.global = mockHttp;
    });
    test('Allow', () async {
      final http.Response response = await http
          .get(Uri(scheme: 'https', host: 'www.google.com'))
          .catchError((e) {
        expect(false, true, reason: 'Expecting no error on http get');
        return http.Response('', HttpStatus.noContent);
      });
      expect(response.body.contains('Google'), true);
    });
    test('Not allow', () async {
      mockHttp.allowHttpClientWhenNoMock = false;
      final http.Response response = await http
          .get(Uri(scheme: 'https', host: 'www.google.com'))
          // ignore: avoid_annotating_with_dynamic
          .catchError((dynamic e) {
        expect(e, 'No mock for GET https://www.google.com');
        return http.Response('', HttpStatus.noContent);
      });
      expect(response.body.isEmpty, true);
      expect(response.statusCode, HttpStatus.noContent);
    });
  });
}
