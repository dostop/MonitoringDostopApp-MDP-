import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'api_http_client.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'dostop.mx';

  AuthService({http.Client? client}) : _client = client ?? ApiHttpClient.instance.client;

  final http.Client _client;

  final storage = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<String?> login(username, password) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
    };

    try {
      final url = Uri.https(_baseUrl, '/api/AppGuardias/loginApp');
      final resp = await _client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(authData));
      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp.containsKey('token')) {
        log("decodresp: $decodeResp");
        await storage.write(key: 'token', value: decodeResp['token']);
        //_prefs.idComdominium = decodeResp['id'].toString();
        return null;
      } else {
        if (resp.statusCode == 401 || resp.statusCode == 403) {
          return 'El usuario y/o contraseña no son correctos.';
        } else {
          return 'Ingrese su usuario y/o contraseña.';
        }
      }
    } catch (e) {
      return messageError(e);
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> statusFracc() async {
    try {
      final token = await storage.read(key: 'token') ?? '';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      };

      final url = Uri.https(_baseUrl, '/api/statusFracc');
      final resp = await _client.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (resp.statusCode == 403) {
        return '403';
      }

      if (decodeResp.containsKey('statusFracc')) {
        return decodeResp['statusFracc'];
      }
      return '';
    } catch (e) {
      return 'error';
    }
  }
}
