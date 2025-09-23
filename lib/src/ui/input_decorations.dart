import 'package:flutter/material.dart';

import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hintText, required String labelText}) {
    return InputDecoration(
        filled: true,
        fillColor: fillColor,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: mainBlueColor,
            )),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: darkTextColor),
        hintStyle: const TextStyle(color: darkTextColor));
  }

  static InputDecoration visitorInputDecoration(
      {required String hintText, required String labelText}) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        // border: UnderlineInputBorder(borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: mainGrayColor),
        hintStyle: const TextStyle(color: mainGrayColor),
        errorStyle: const TextStyle(fontSize: 18));
  }

  static InputDecoration searchInputDecoration(
      {required String hintText, required String labelText}) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: labelText,
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(color: mainGrayColor),
        hintStyle: const TextStyle(color: mainGrayColor),
        errorStyle: const TextStyle(fontSize: 18));
  }

  static InputDecoration numberInputDecoration(
      {required String hintText, required String labelText}) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(style: BorderStyle.none)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: mainBlueColor)),
        labelText: labelText,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(10),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(color: mainGrayColor),
        hintStyle: const TextStyle(color: mainGrayColor),
        errorStyle: const TextStyle(fontSize: 18));
  }
}
