import 'dart:developer';

import 'package:flutter_dostop_monitoreo/src/screens/home.dart';
import 'package:flutter_dostop_monitoreo/src/services/auth_services.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Image.asset(rutaLogoLetras2023));
            }
            log(snapshot.data);
            if (snapshot.data.isEmpty || snapshot.data == null) {
              log('para login');
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              log('para home');
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }

            return Center(child: Image.asset(rutaLogoLetras2023));
          },
        ),
      ),
    );
  }
}
