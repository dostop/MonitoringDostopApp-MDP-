

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiHttpClient {
  ApiHttpClient._(this._client, this._context);

  final http.Client _client;
  final SecurityContext _context;
  final Map<String, String> _etagCache = <String, String>{};
  final Map<String, String> _lastModifiedCache = <String, String>{};

  static ApiHttpClient? _instance;

  static ApiHttpClient get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError('ApiHttpClient.initialize must be called before use.');
    }
    return instance;
  }

  http.Client get client => _client;
  SecurityContext get securityContext => _context;


  /// Returns the cached ETag associated with [url], if any.
  String? getEtag(String url) => _etagCache[url];

  /// Stores or clears the cached ETag for [url].
  void setEtag(String url, String? etag) {
    if (etag == null || etag.isEmpty) {
      _etagCache.remove(url);
    } else {
      _etagCache[url] = etag;
    }
  }

  /// Returns the cached Last-Modified header associated with [url], if any.
  String? getLastModified(String url) => _lastModifiedCache[url];

  /// Stores or clears the cached Last-Modified header for [url].
  void setLastModified(String url, String? value) {
    if (value == null || value.isEmpty) {
      _lastModifiedCache.remove(url);
    } else {
      _lastModifiedCache[url] = value;
    }
  }

  /// Internal helper for tests to check if the client was initialised.
  static ApiHttpClient? get maybeInstance => _instance;

  static Future<void> initialize({String? certificateAssetPath}) async {
    if (_instance != null) {
      return;
    }


    final context = SecurityContext(withTrustedRoots: true);

    final ioHttp = HttpClient(context: context)
      ..idleTimeout = const Duration(seconds: 10)
      ..connectionTimeout = const Duration(seconds: 12)
      ..autoUncompress = true
      ..userAgent = 'DostopMonitoreo/1.0'
      ..badCertificateCallback = (cert, host, port) => true;

    HttpOverrides.global = _ApiHttpOverrides(context);

    final ioClient = IOClient(ioHttp);
    _instance = ApiHttpClient._(ioClient, context);
  }
}

class _ApiHttpOverrides extends HttpOverrides {
  _ApiHttpOverrides(this.context);

  final SecurityContext context;

  @override
  HttpClient createHttpClient(SecurityContext? _) {
    final ioHttp = HttpClient(context: context)
      ..idleTimeout = const Duration(seconds: 10)
      ..connectionTimeout = const Duration(seconds: 12)
      ..autoUncompress = true
      ..userAgent = 'DostopMonitoreo/1.0'
      ..badCertificateCallback = (cert, host, port) => true;
    return ioHttp;
  }
}

