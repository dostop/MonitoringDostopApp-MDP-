import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiHttpClient {
  ApiHttpClient._(this._client, this._context);

  final http.Client _client;
  final SecurityContext _context;

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

  static Future<void> initialize(String certificateAssetPath) async {
    if (_instance != null) {
      return;
    }

    final data = await rootBundle.load(certificateAssetPath);
    final bytes = data.buffer.asUint8List();
    final context = SecurityContext(withTrustedRoots: true);
    context.setTrustedCertificatesBytes(bytes);

    final httpClient = HttpClient(context: context);
    HttpOverrides.global = _ApiHttpOverrides(context);
    _instance = ApiHttpClient(IOClient(httpClient), context);
  }
}

class _ApiHttpOverrides extends HttpOverrides {
  _ApiHttpOverrides(this.context);

  final SecurityContext context;

  @override
  HttpClient createHttpClient(SecurityContext? _) {
    return HttpClient(context: context);
  }
}
