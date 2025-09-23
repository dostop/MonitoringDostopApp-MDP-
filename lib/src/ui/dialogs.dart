import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_dostop_monitoreo/src/ui/input_decorations.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

openDialogSimple(
    BuildContext context, String title, String contenido, String textOpcionOK) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.all(15),
          backgroundColor: Theme.of(context).cardColor,
          actions: [
            const Divider(),
            DialogButton(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                height: 80,
                color: Colors.transparent,
                child: Text(
                  textOpcionOK,
                  style: const TextStyle(fontSize: 25, color: mainBlueColor),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                })
          ],
          content: SizedBox(
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(title,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center)),
                Text(contenido,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).textTheme.bodyLarge!.color))
              ],
            ),
          ),
        );
      });
}

openAlertBoxField(BuildContext context, TextEditingController controller,
    String title, String label, VoidCallback functionYes) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.all(15),
          backgroundColor: Theme.of(context).cardColor,
          actions: [
            Row(
              children: [
                Expanded(
                  child: DialogButton(
                      height: 90,
                      color: mainGreenColor,
                      child: const Text(
                        'Autorizar',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      onPressed: () {
                        functionYes.call();
                      }),
                ),
                Expanded(
                  child: DialogButton(
                      height: 90,
                      color: mainBlueColor,
                      child: const Text('Cancelar',
                          style: TextStyle(fontSize: 25, color: Colors.white)),
                      onPressed: () {
                        controller.clear();
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      }),
                )
              ],
            )
          ],
          content: SizedBox(
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center)),
                TextField(
                  controller: controller,
                  autofocus: true,
                  autocorrect: false,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                  decoration: InputDecorations.visitorInputDecoration(
                      hintText: label, labelText: label),
                )
              ],
            ),
          ),
        );
      });
}

openAlertBoxSimple(BuildContext context, String title, String contentAlert,
    {bool error = false, bool visibleContent = true, bool showButton = true}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: Theme.of(context).cardColor,
          content: SizedBox(
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: error
                                ? mainRedColor
                                : Theme.of(context).textTheme.bodyLarge!.color),
                        textAlign: TextAlign.center)),
                Visibility(
                    visible: visibleContent,
                    child: const SizedBox(height: 5.0)),
                Visibility(
                  visible: visibleContent,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text(contentAlert,
                          style: TextStyle(
                              fontSize: 30,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                          textAlign: TextAlign.center)),
                ),
                Container(
                    padding: EdgeInsets.all(showButton ? 15.0 : 30.0),
                    alignment: Alignment.bottomRight,
                    child: Visibility(
                      visible: showButton,
                      child: ElevatedButton(
                        child: const Text(
                          'OK',
                          style: TextStyle(fontSize: 25),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 8,
                            primary: mainGreenColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            fixedSize: const Size(90, 90)),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        },
                      ),
                    )),
              ],
            ),
          ),
        );
      });
}

openAlertBoxConfirm(BuildContext context,
    {String title = '',
    String contentAlert = '',
    bool error = false,
    visibleTitle = true,
    TextAlign textAlign = TextAlign.center,
    required VoidCallback functionYes,
    required VoidCallback functionNo}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.all(15),
          backgroundColor: Theme.of(context).cardColor,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 15),
                Visibility(
                  visible: visibleTitle,
                  child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: error
                                  ? mainRedColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                          textAlign: TextAlign.center)),
                ),
                const SizedBox(height: 5.0),
                Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: AutoSizeText(contentAlert,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: textAlign)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: const Text(
                        'Sí',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          primary: mainGreenColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.25,
                              MediaQuery.of(context).size.height * 0.1)),
                      onPressed: () {
                        functionYes.call();
                      },
                    ),
                    ElevatedButton(
                        child: const Text(
                          'No',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 8,
                            primary: mainRedColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.25,
                                MediaQuery.of(context).size.height * 0.1)),
                        onPressed: () => functionNo.call()),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        );
      });
}

creaDialogProgress(BuildContext context, String titulo) {
  showCupertinoDialog(
      context: context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: CupertinoAlertDialog(
            title: Text(titulo),
            content: const CupertinoActivityIndicator(
              radius: 20,
            ),
          ),
        );
      });
}
