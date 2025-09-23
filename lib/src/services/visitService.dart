import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';

class VisitService extends ChangeNotifier {
  //final String _baseUrl = '192.168.100.7';
  final String _prod = 'dostop.mx';

  final _storage = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //final tok =      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjMiLCJpZEZyYWNjaW9uYW1pZW50byI6IjEiLCJ1c2VybmFtZSI6Imd1YXJkaWFkZW1vIn0.BkCJkrxR_YYG72ODCw5k8BTM7kBQbNWBdsSAg7I7jao';

  Future<Map<String, dynamic>> ultimaVisitaVehicular() async {
    final token = await _storage.read(key: 'token') ?? '';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
      //'Authorization': 'Bearer ' + tok
    };

    try {
      final url = Uri.https(_prod, '/api/AppGuardias/mVisitaVehicular');
      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      return decodeResp;
    } catch (e) {
      log('error visita vehicular: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaSalidaVehicular() async {
    final token = await _storage.read(key: 'token') ?? '';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
      //'Authorization': 'Bearer ' + tok
    };

    try {
      final url = Uri.https(_prod, '/api/AppGuardias/mSalidaVehicular');
      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      return decodeResp;
    } catch (e) {
      log('error salida vehicular: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaVisitaPeatonal() async {
    final token = await _storage.read(key: 'token') ?? '';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
      //'Authorization': 'Bearer ' + tok
    };

    try {
      final url = Uri.https(_prod, '/api/AppGuardias/mVisitaPeatonal');
      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      return decodeResp;
    } catch (e) {
      log('error entrada peatonal: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaSalidaPeatonal() async {
    final token = await _storage.read(key: 'token') ?? '';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
      //'Authorization': 'Bearer ' + tok
    };

    try {
      final url = Uri.https(_prod, '/api/AppGuardias/mSalidaPeatonal');
      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      return decodeResp;
    } catch (e) {
      log('error salida peatonal: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaVisitafacial() async {
    final token = await _storage.read(key: 'token') ?? '';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
      //'Authorization': 'Bearer ' + tok
    };

    try {
      final url = Uri.https(_prod, '/api/AppGuardias/ultimaVisitaFacial');
      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      return decodeResp;
    } catch (e) {
      log('error visita facial: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }

  Future<Map<String, dynamic>> ultimaSalidaFacial() async {
    final token = await _storage.read(key: 'token') ?? '';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
      //'Authorization': 'Bearer ' + tok
    };

    try {
      final url = Uri.https(_prod, '/api/AppGuardias/ultimaSalidaFacial');
      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      return decodeResp;
    } catch (e) {
      log('error salida facial: $e');
      return {'statusCode': 0, 'status': 'error', 'message': messageError(e)};
    }
  }
}
