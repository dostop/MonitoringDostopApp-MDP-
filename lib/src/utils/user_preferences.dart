import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences with ChangeNotifier {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  late SharedPreferences _prefs;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get idComdominium {
    return _prefs.getString('idCondominium') ?? '';
  }

  set idComdominium(String id) {
    _prefs.setString('idCondominium', id);
  }

  String get themeMode {
    return _prefs.getString('tema') ?? 'Dark';
  }

  set themeMode(String value) {
    _prefs.setString('tema', value);
  }

  set accesoVehicular(int value) {
    _prefs.setInt('accesoVehicular', value);
  }

  int get accesoVehicular {
    return _prefs.getInt('accesoVehicular') ?? 1;
  }

  set accesoPeatonal(int value) {
    _prefs.setInt('accesoPeatonal', value);
  }

  int get accesoPeatonal {
    return _prefs.getInt('accesoPeatonal') ?? 1;
  }

  set accesoFacial(int value) {
    _prefs.setInt('accesoFacial', value);
  }

  int get accesoFacial {
    return _prefs.getInt('accesoFacial') ?? 1;
  }

  /* set accesoTag(int value) {
    _prefs.setInt('accesoTag', value);
  }

  int get accesoTag {
    return _prefs.getInt('accesoTag') ?? 1;
  } */

  borraPrefs() async {
    await _prefs.remove('room');
  }
}
