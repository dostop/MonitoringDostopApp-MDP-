// lib/src/services/visitService.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'api_http_client.dart';

class VisitService extends ChangeNotifier {
  VisitService({
    this.host = 'dostop.mx',
    this.scheme = 'https',
  })  : _client = ApiHttpClient.instance.client,
        _storage = const FlutterSecureStorage();

  final String host;           // <-- reemplaza a _prod
  final String scheme;
  final http.Client _client;   // <-- cliente del ApiHttpClient
  final FlutterSecureStorage _storage;

  /// Headers para GET. Para endpoints problemáticos, usa [hardened:true]

  Map<String, String> _headers({required String token, bool hardened = false}) {
    final base = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (hardened) {
      // Evita gzip/chunked y reuso de sockets (mitiga "Connection closed...")
      base['Accept-Encoding'] = 'identity';
      base['Connection'] = 'close';
    }
    return base;
  }

  Future<http.Response> _retryGet(
      Uri uri, {
        required Map<String, String> headers,
        int retries = 3,
      }) async {
    late Object lastErr;
    for (var i = 0; i < retries; i++) {
      try {
        return await _client.get(uri, headers: headers);
      } catch (e) {
        lastErr = e;
        await Future.delayed(Duration(milliseconds: 300 * (i + 1))); // backoff
      }
    }
    throw lastErr;
  }

  Future<Map<String, dynamic>> _getJsonPath(
      String path, {
        required String token,
        bool hardened = false,
        int retries = 3,
      }) async {
    try {
      final uri = Uri(scheme: scheme, host: host, path: path);
      final resp = await _retryGet(
        uri,
        headers: _headers(token: token, hardened: hardened),
        retries: retries,
      );

      final text = utf8.decode(resp.bodyBytes);
      dynamic body;
      try {
        body = json.decode(text);
      } catch (_) {
        body = {'raw': text};
      }

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return body is Map<String, dynamic>
            ? body
            : <String, dynamic>{'data': body, 'statusCode': resp.statusCode};
      }

      return {
        'statusCode': resp.statusCode,
        'status': 'error',
        'message':
        (body is Map && body['message'] != null) ? '${body['message']}' : 'Http ${resp.statusCode}',
        'data': body,
      };
    } catch (e) {
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  // =========================
  // Vehicular
  // =========================

  Future<Map<String, dynamic>> ultimaVisitaVehicular() async {
    final token = await _storage.read(key: 'token') ?? '';
    try {
      return await _getJsonPath('/api/AppGuardias/mVisitaVehicular',
          token: token, hardened: true);
    } catch (e) {
      log('error visita vehicular: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaSalidaVehicular() async {
    final token = await _storage.read(key: 'token') ?? '';
    try {
      return await _getJsonPath('/api/AppGuardias/mSalidaVehicular',
          token: token, hardened: true);
    } catch (e) {
      log('error salida vehicular: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  // =========================
  // Peatonal
  // =========================

  Future<Map<String, dynamic>> ultimaVisitaPeatonal() async {
    final token = await _storage.read(key: 'token') ?? '';
    try {
      return await _getJsonPath('/api/AppGuardias/mVisitaPeatonal',
          token: token, hardened: true);
    } catch (e) {
      log('error entrada peatonal: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaSalidaPeatonal() async {
    final token = await _storage.read(key: 'token') ?? '';
    try {
      return await _getJsonPath('/api/AppGuardias/mSalidaPeatonal',
          token: token, hardened: true);
    } catch (e) {
      log('error salida peatonal: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  // =========================
  // Facial  (estas eran las que fallaban)
  // =========================

  Future<Map<String, dynamic>> ultimaVisitafacial() async {
    final token = await _storage.read(key: 'token') ?? '';
    try {
      return await _getJsonPath('/api/AppGuardias/ultimaVisitaFacial',
          token: token, hardened: true);
    } catch (e) {
      log('error visita facial: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaSalidaFacial() async {
    final token = await _storage.read(key: 'token') ?? '';
    try {
      return await _getJsonPath('/api/AppGuardias/ultimaSalidaFacial',
          token: token, hardened: true);
    } catch (e) {
      log('error salida facial: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  // (Opcional) si en algún lugar ya llamas a estos nombres:

  Future<Map<String, dynamic>> getUltimaVisitaFacial({
    int retries = 3,
  }) async {
    final token = await _storage.read(key: 'token') ?? '';
    return _getJsonPath('/api/AppGuardias/ultimaVisitaFacial',
        token: token, hardened: true, retries: retries);
  }

  Future<Map<String, dynamic>> getUltimaSalidaFacial({
    int retries = 3,
  }) async {
    final token = await _storage.read(key: 'token') ?? '';
    return _getJsonPath('/api/AppGuardias/ultimaSalidaFacial',
        token: token, hardened: true, retries: retries);
  }
}
