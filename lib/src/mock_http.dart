import 'dart:io';

import 'package:http/http.dart';

import 'mock_http_client.dart';
import 'mock_http_client_request_data.dart';

class MockHttp extends HttpOverrides {
  final List<Call> gets = [];
  final List<Call> posts = [];
  final List<Call> puts = [];
  final List<Call> deletes = [];
  final List<Call> heads = [];
  final List<Call> patchs = [];
  final String? defaultScheme;
  final String? defaultHost;
  final int? defaultPort;
  bool allowHttpClientWhenNoMock;

  MockHttp(
      {this.defaultScheme,
      this.defaultHost,
      this.defaultPort,
      this.allowHttpClientWhenNoMock = true});

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient(super.createHttpClient(context),
        gets: gets,
        posts: posts,
        puts: puts,
        deletes: deletes,
        heads: heads,
        patchs: patchs,
        allowHttpClientWhenNoMock: allowHttpClientWhenNoMock);
  }

  void registerGet(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      gets.add(Call(uri, response));

  void registerPost(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      posts.add(Call(uri, response));

  void registerPut(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      puts.add(Call(uri, response));

  void registerDelete(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      deletes.add(Call(uri, response));

  void registerHead(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      heads.add(Call(uri, response));

  void registerPatch(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      patchs.add(Call(uri, response));

  void registerGets(
      {String? scheme,
      String? host,
      int? port,
      required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses}) {
    _register(scheme, host, port, pathResponses, registerGet);
  }

  void registerPosts(
      {String? scheme,
      String? host,
      int? port,
      required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses}) {
    _register(scheme, host, port, pathResponses, registerPost);
  }

  void registerPuts(
      {String? scheme,
      String? host,
      int? port,
      required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses}) {
    _register(scheme, host, port, pathResponses, registerPut);
  }

  void registerDeletes(
      {String? scheme,
      String? host,
      int? port,
      required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses}) {
    _register(scheme, host, port, pathResponses, registerDelete);
  }

  void registerHeads(
      {String? scheme,
      String? host,
      int? port,
      required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses}) {
    _register(scheme, host, port, pathResponses, registerHead);
  }

  void registerPatchs(
      {String? scheme,
      String? host,
      int? port,
      required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses}) {
    _register(scheme, host, port, pathResponses, registerPatch);
  }

  void _register(
      String? scheme,
      String? host,
      int? port,
      Map<String, Response Function(MockHttpClientRequestData)> pathResponses,
      void Function(Uri, Response Function(MockHttpClientRequestData)) f) {
    scheme = scheme ?? defaultScheme;
    host = host ?? defaultHost;
    port = port ?? defaultPort;
    for (MapEntry<String, Response Function(MockHttpClientRequestData)> entry
        in pathResponses.entries) {
      f(Uri(scheme: scheme, host: host, path: entry.key), entry.value);
    }
  }
}
