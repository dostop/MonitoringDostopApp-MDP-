import 'package:flutter_dostop_monitoreo/src/screens/check_auth.dart';
import 'package:flutter_dostop_monitoreo/src/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dostop_monitoreo/src/screens/login.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:flutter_dostop_monitoreo/src/screens/home.dart';
import 'package:flutter_dostop_monitoreo/src/utils/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  final prefs = UserPreferences();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0), child: child!);
      },
      title: 'Dostop Monitoreo',
      locale: const Locale('es'),
      initialRoute: 'checking',
      routes: {
        'checking': (_) => const CheckAuthScreen(),
        'login': (_) => const LoginScreen(),
        'home': (BuildContext context) => const HomeScreen(),
        'setting': (_) => SettingScreen()
      },
      debugShowCheckedModeBanner: false,
      themeMode: prefs.themeMode == 'Dark' ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
          fontFamily: 'PlusJakarta',
          brightness: Brightness.light,
          scaffoldBackgroundColor: lightBackgroundColor,
          cardColor: Colors.white,
          primaryColor: mainBlueColor,
          progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: mainBlueColor),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Colors.black),
            displayLarge: TextStyle(color: Colors.black),
            bodyLarge: TextStyle(color: Colors.black),
          ),
          appBarTheme: const AppBarTheme(
              color: lightBackgroundColor,
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.black),
              toolbarTextStyle: TextStyle(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black),
              actionsIconTheme: IconThemeData(color: Colors.black)),
          snackBarTheme:
          const SnackBarThemeData(actionTextColor: lightBackgroundColor),
          colorScheme:
          ColorScheme.fromSwatch(primarySwatch: mainBlueMaterialColor)
              .copyWith(background: lightBackgroundColor)),
      darkTheme: ThemeData(
        fontFamily: 'PlusJakarta',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackgroundColor,
        primaryColor: darkBackgroundColor,
        progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: mainBlueColor),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: mainBlueColor,
            selectionHandleColor: mainBlueColor,
            selectionColor: mainBlueColor),
        indicatorColor: mainBlueColor,
        appBarTheme: const AppBarTheme(
            color: darkBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white)),
        cardColor: cardDarkColor,
        snackBarTheme:
        const SnackBarThemeData(actionTextColor: darkBackgroundColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontFamily: 'PlusJakarta'))),
      ),
    );
  }

  void changeTheme() {
    setState(() {
      prefs.themeMode = prefs.themeMode == 'Dark' ? 'Light' : 'Dark';
    });
  }
}