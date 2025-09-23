import 'package:flutter/material.dart';

const Color darkBackgroundColor = Color.fromRGBO(22, 29, 40, 1.0);
const Color lightBackgroundColor = Color.fromRGBO(245, 244, 249, 1.0);
const Color darkTextColor = Color.fromRGBO(184, 184, 184, 1.0);
const Color iconColor = Color.fromRGBO(65, 64, 64, 1.0);
const Color loginBackgroundColor = Color.fromRGBO(0, 0, 0, 0.70);
const Color fillColor = Color.fromRGBO(0, 0, 0, 0.60);
const Color mainBlueColor = Color.fromRGBO(2, 69, 232, 1.0);
const Color secondaryBlueColor = Color.fromRGBO(2, 69, 232, 1.0);
const Color mainGrayColor = Color.fromRGBO(102, 106, 106, 1.0);
const Color secondaryGrayColor = Color.fromRGBO(96, 96, 96, 1.0);
const Color lightGrayColor = Color.fromRGBO(128, 128, 128, 0.8);
const Color mainGreenColor = Color.fromRGBO(2, 183, 84, 1.0);
const Color mainRedColor = Color.fromRGBO(235, 51, 51, 1.0);
const Color darkCardColor = Color.fromRGBO(202, 202, 202, 1.0);
const Color spinnerColor = Color.fromRGBO(168, 168, 168, 1.0);
const Color cardDarkColor = Color.fromRGBO(32, 45, 61, 1.0);
const Color colorFondoTarjetaFreq = Color.fromRGBO(226, 226, 226, 1.0);

MaterialColor mainBlueMaterialColor =
    const MaterialColor(0xFF0245E8, _swatchColor);
const Map<int, Color> _swatchColor = {
  50: Color(0xFF0245E8),
  100: Color(0xFF0245E8),
  200: Color(0xFF0245E8),
  300: Color(0xFF0245E8),
  400: Color(0xFF0245E8),
  500: Color(0xFF003CCE),
  600: Color(0xFF003CCE),
  700: Color(0xFF003CCE),
  800: Color(0xFF003CCE),
  900: Color(0xFF003CCE)
};

String pathLogoDostopText = 'assets/LogoLetrasColores2023.png';
String rutaLogo2023 = 'assets/Logo2023.png';
String rutaLogoColores2023 = 'assets/LogoColores2023.png';
String rutaLogoLetras2023 = 'assets/LogoLetras2023.png';

LinearGradient linearGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [mainBlueColor, secondaryBlueColor]);

LinearGradient linearGradientDisabled = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [mainGrayColor, secondaryGrayColor]);

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.transparent,
    elevation: 8,
    padding: const EdgeInsets.all(0.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    textStyle: const TextStyle(fontSize: 18));

final ButtonStyle returnButtonStyle = ElevatedButton.styleFrom(
  primary: mainGreenColor,
  elevation: 8,
  alignment: Alignment.center,
  padding: const EdgeInsets.all(15.0),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15))),
  textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
);

String capitalizationWords(String text) {
  var splitStr = text.toLowerCase().split(' ');

  for (var i = 0; i < splitStr.length; i++) {
    if (splitStr[i].toString().isNotEmpty) {
      splitStr[i] =
          splitStr[i].substring(0, 1).toUpperCase() + splitStr[i].substring(1);
    }
  }
  text = splitStr.join(' ');

  return text;
}

TextEditingController backspace(TextEditingController controller) {
  try {
    final text = controller.text;
    final textSelection = controller.selection;
    final selectionLength = textSelection.end - textSelection.start;
    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      controller.text = newText;
      controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return controller;
    }
    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return controller;
    }
    // Delete the previous character
    final newStart = textSelection.start - 1;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    controller.text = newText;
    controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
    // ignore: empty_catches
  } catch (e) {}

  return controller;
}

TextEditingController insertText(
    TextEditingController controller, String myText,
    {bool capitalization = true, bool temporaryCode = false}) {
  try {
    final text = controller.text;
    final textSelection = controller.selection;
    int myTextLength;
    String newText;

    newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    myTextLength = myText.length;

    if (temporaryCode) {
      String str = newText.replaceAll("-", "");
      RegExp exp = RegExp(r"\d{" "1" "}");
      Iterable<Match> matches = exp.allMatches(str);
      var list = matches.map((m) => m.group(0));
      var code = "";
      int index = 0;
      for (var item in list) {
        if (index == 3) {
          code += "-$item";
          myTextLength = 2;
          index = 0;
        } else {
          code += item.toString();
          myTextLength = myText.length;
        }
        index = index + 1;
      }
      newText = code;
    }

    controller.text = capitalization ? capitalizationWords(newText) : newText;
    controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
    // ignore: empty_catches
  } catch (e) {}

  return controller;
}

TextStyle textStyleBold(double fontSize) {
  return TextStyle(
      fontFamily: 'PlusJakarta',
      fontWeight: FontWeight.bold,
      fontSize: fontSize);
}

List<String> validImages(List<String> imagenes) {
  List<String> list = [];
  list.addAll(imagenes);
  for (var item in imagenes) {
    if (item == '') list.remove(item);
  }
  return list;
}

String messageError(Object e) {
  return e.runtimeType.toString() == 'SocketException'
      ? 'Ha ocurrido un error, favor verificar conexión a internet.'
      : e.toString();
}

TextStyle estiloBotones(double fontSize, {Color color = Colors.white}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w900,
  );
}
