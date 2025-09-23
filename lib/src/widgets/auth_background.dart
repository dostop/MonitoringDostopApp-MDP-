import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(
          'assets/background.jpg',
          fit: BoxFit.cover,
        ),
        Container(
          color: loginBackgroundColor,
        ),
        child,
      ]),
    );
  }
}
