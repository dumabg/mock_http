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

  Uri _pathToUri(String path) {
    final uri = Uri.parse(path);
    return Uri(
        scheme: uri.hasScheme ? uri.scheme : defaultScheme,
        host: uri.host.isEmpty ? defaultHost : uri.host,
        port: uri.hasPort ? uri.port : defaultPort,
        path: uri.pathSegments.isEmpty ? uri.path : null,
        fragment: uri.fragment.isEmpty ? null : uri.fragment,
        pathSegments: uri.pathSegments.isEmpty ? null : uri.pathSegments,
        query: uri.queryParameters.isEmpty ? uri.query : null,
        queryParameters:
            uri.queryParameters.isEmpty ? null : uri.queryParameters,
        userInfo: uri.userInfo.isEmpty ? null : uri.userInfo);
  }

  void registerUriGet(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      gets.add(Call(uri, response));

  void registerGet(
          String path, Response Function(MockHttpClientRequestData) response) =>
      gets.add(Call(_pathToUri(path), response));

  void registerUriPost(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      posts.add(Call(uri, response));

  void registerPost(
          String path, Response Function(MockHttpClientRequestData) response) =>
      posts.add(Call(_pathToUri(path), response));

  void registerUriPut(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      puts.add(Call(uri, response));

  void registerPut(
          String path, Response Function(MockHttpClientRequestData) response) =>
      puts.add(Call(_pathToUri(path), response));

  void registerUriDelete(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      deletes.add(Call(uri, response));

  void registerDelete(
          String path, Response Function(MockHttpClientRequestData) response) =>
      deletes.add(Call(_pathToUri(path), response));

  void registerUriHead(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      heads.add(Call(uri, response));

  void registerHead(
          String path, Response Function(MockHttpClientRequestData) response) =>
      heads.add(Call(_pathToUri(path), response));

  void registerUriPatch(
          Uri uri, Response Function(MockHttpClientRequestData) response) =>
      patchs.add(Call(uri, response));

  void registerPatch(
          String path, Response Function(MockHttpClientRequestData) response) =>
      patchs.add(Call(_pathToUri(path), response));

  void registerGets(
      {required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses,
      String? scheme,
      String? host,
      int? port}) {
    _register(scheme, host, port, pathResponses, registerUriGet);
  }

  void registerPosts(
      {required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses,
      String? scheme,
      String? host,
      int? port}) {
    _register(scheme, host, port, pathResponses, registerUriPost);
  }

  void registerPuts(
      {required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses,
      String? scheme,
      String? host,
      int? port}) {
    _register(scheme, host, port, pathResponses, registerUriPut);
  }

  void registerDeletes(
      {required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses,
      String? scheme,
      String? host,
      int? port}) {
    _register(scheme, host, port, pathResponses, registerUriDelete);
  }

  void registerHeads(
      {required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses,
      String? scheme,
      String? host,
      int? port}) {
    _register(scheme, host, port, pathResponses, registerUriHead);
  }

  void registerPatchs(
      {required Map<String, Response Function(MockHttpClientRequestData)>
          pathResponses,
      String? scheme,
      String? host,
      int? port}) {
    _register(scheme, host, port, pathResponses, registerUriPatch);
  }

  void _register(
      String? scheme,
      String? host,
      int? port,
      Map<String, Response Function(MockHttpClientRequestData)> pathResponses,
      void Function(Uri, Response Function(MockHttpClientRequestData)) f) {
    for (final MapEntry<String,
            Response Function(MockHttpClientRequestData)> entry
        in pathResponses.entries) {
      f(
          Uri(
              scheme: scheme ?? defaultScheme,
              host: host ?? defaultHost,
              port: port ?? defaultPort,
              path: entry.key),
          entry.value);
    }
  }
}
