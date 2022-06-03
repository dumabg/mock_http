import 'dart:io';
import 'package:http/http.dart' as $http;
import 'package:mock_http/mock_http.dart';

void main() async {
  HttpOverrides.global = MockHttp(
      defaultScheme: 'https',
      defaultHost: 'www.google.com',
      allowHttpClientWhenNoMock: false)
    ..registerGets(pathResponses: {
      '/hola': (_) => $http.Response('Hola', HttpStatus.ok),
      '/pepe': (_) => $http.Response('Hola Pepe', HttpStatus.ok)
    })
    ..registerPosts(pathResponses: {
      '': (_) => $http.Response('POST done', HttpStatus.badRequest),
    });

  $http.Response response = await $http
      .get(Uri(scheme: 'https', host: 'www.google.com', path: '/hola'));
  print(response.body);
  print(response.statusCode);

  response = await $http
      .get(Uri(scheme: 'https', host: 'www.google.com', path: '/pepe'));
  print(response.body);
  print(response.statusCode);

  response = await $http.post(Uri(scheme: 'https', host: 'www.google.com'));
  print(response.body);
  print(response.statusCode);

  response = await $http.get(Uri(scheme: 'https', host: 'www.google.com'));
  print(response.body);
  print(response.statusCode);
}
