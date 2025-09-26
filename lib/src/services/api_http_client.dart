

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  static Future<void> initialize() async {
    if (_instance != null) return;

    final context = SecurityContext(withTrustedRoots: true);

    final ioHttp = HttpClient(context: context)
      ..idleTimeout = const Duration(seconds: 10)
      ..connectionTimeout = const Duration(seconds: 12)
      ..autoUncompress = true
      ..userAgent = 'DostopMonitoreo/1.0';

    // Si requieres aceptar un cert self-signed en pruebas, descomenta:
    // ioHttp.badCertificateCallback = (cert, host, port) => false;

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
      ..userAgent = 'DostopMonitoreo/1.0';
    return ioHttp;
  }
}

