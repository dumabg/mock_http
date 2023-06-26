import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';

import 'mock_http_client_request.dart';
import 'mock_http_client_request_data.dart';

class Call {
  final Uri uri;
  final Response Function(MockHttpClientRequestData) f;

  Call(this.uri, this.f);
}

enum _DispatchKind {get, post, put, delete, head, patch}

class MockHttpClient implements HttpClient {
  HttpClient httpClient;
  final List<Call> gets;
  final List<Call> posts;
  final List<Call> puts;
  final List<Call> deletes;
  final List<Call> heads;
  final List<Call> patchs;
  final bool allowHttpClientWhenNoMock;

  MockHttpClient(this.httpClient,
      {required this.gets,
      required this.posts,
      required this.puts,
      required this.deletes,
      required this.heads,
      required this.patchs,
      required this.allowHttpClientWhenNoMock});

  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      deleteUrl(Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> deleteUrl(Uri uri) =>
      _dispatch(_DispatchKind.delete, deletes, uri, httpClient.deleteUrl);

  @override
  set findProxy(String Function(Uri url)? f) {
    httpClient.findProxy = f;
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      getUrl(Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> getUrl(Uri uri) =>
      _dispatch(_DispatchKind.get, gets, uri, httpClient.getUrl);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      headUrl(Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> headUrl(Uri uri) =>
      _dispatch(_DispatchKind.head, heads, uri, httpClient.headUrl);

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    return openUrl(method, Uri(host: host, port: port, path: path));
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri uri) {
    switch (method) {
      case 'GET':
        return getUrl(uri);
      case 'POST':
        return postUrl(uri);
      case 'PUT':
        return putUrl(uri);
      case 'DELETE':
        return deleteUrl(uri);
      case 'HEAD':
        return headUrl(uri);
      case 'PATCH':
        return patchUrl(uri);
      default:
        return Future.error('Unsupported method: $method');
    }
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      patchUrl(Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> patchUrl(Uri uri) =>
      _dispatch(_DispatchKind.patch, patchs, uri, httpClient.patchUrl);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      postUrl(Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> postUrl(Uri uri) =>
      _dispatch(_DispatchKind.post, posts, uri, httpClient.postUrl);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      putUrl(Uri(host: host, port: port, path: path));

  @override
  Future<HttpClientRequest> putUrl(Uri uri) =>
      _dispatch(_DispatchKind.put, puts, uri, httpClient.putUrl);

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {
    httpClient.addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {
    httpClient.addProxyCredentials(host, port, realm, credentials);
  }

  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String? realm)? f) {
    httpClient.authenticate = f;
  }

  @override
  set authenticateProxy(
      Future<bool> Function(
              String host, int port, String scheme, String? realm)?
          f) {
    httpClient.authenticateProxy = f;
  }

  @override
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)? callback) {
    httpClient.badCertificateCallback = callback;
  }

  @override
  void close({bool force = false}) {
    httpClient.close(force: force);
  }

  Future<HttpClientRequest> _dispatch(_DispatchKind kind, List<Call> calls, Uri uri,
      Future<HttpClientRequest> Function(Uri) defaultHttpClientMethod) {
    Response Function(MockHttpClientRequestData)? callFromUri =
        _callFromUri(calls, uri);
    if (callFromUri == null) {
      if (allowHttpClientWhenNoMock) {
          return defaultHttpClientMethod(uri);
      } else {
          var sKind = kind.toString();
          var valueKind = sKind.substring(sKind.lastIndexOf('.') + 1).toUpperCase();
          return Future.error('No mock for $valueKind $uri');
      }
    } else {
      return Future.value(MockHttpClientRequest(
        fCallResponse: callFromUri,
      ));
    }
  }

  Response Function(MockHttpClientRequestData)? _callFromUri(
      List<Call> calls, Uri uri) {
    for (Call call in calls) {
      if (call.uri.toString() == uri.toString()) {
        return call.f;
      }
    }
    return null;
  }

  @override
  set connectionFactory(
      Future<ConnectionTask<Socket>> Function(
              Uri url, String? proxyHost, int? proxyPort)?
          f) {}

  @override
  set keyLog(Function(String line)? callback) {}
}
