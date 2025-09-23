import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dostop_monitoreo/src/services/auth_services.dart';
import 'package:flutter_dostop_monitoreo/src/ui/dialogs.dart';
import 'package:flutter_dostop_monitoreo/src/utils/user_preferences.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final authService = AuthService();
  late bool _accesoVehicular, _accesoPeatonal, _accesoFacial /*, _accesoTag */;
  bool _guardando = false;
  final _prefs = UserPreferences();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadValues();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const AutoSizeText('Configuración',
              maxLines: 1, style: TextStyle(fontSize: 25)),
          centerTitle: true,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 40),
            onTap: () => Navigator.pushReplacementNamed(context, 'home'),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                size: 40,
              ),
              onPressed: () async {
                await authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
            const SizedBox(width: 25),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              _createRowOptions(),
              const SizedBox(height: 50),
              _creaBtnGuardar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createRowOptions() {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Opciones de monitoreo',
              style: TextStyle(fontSize: 25),
            )),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        activeColor: mainBlueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: _accesoVehicular,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _accesoVehicular = newValue ?? true;
                          });
                        }),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                      child: AutoSizeText(
                    'Acceso vehicular',
                    minFontSize: 20,
                  ))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        activeColor: mainBlueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: _accesoPeatonal,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _accesoPeatonal = newValue ?? true;
                          });
                        }),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                      child: AutoSizeText('Acceso peatonal', minFontSize: 20))
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        activeColor: mainBlueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: _accesoFacial,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _accesoFacial = newValue ?? true;
                          });
                        }),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                      child: AutoSizeText('Acceso facial', minFontSize: 20))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _creaBtnGuardar() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: mainGreenColor,
            elevation: 8,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            textStyle: const TextStyle(fontSize: 25),
            fixedSize: const Size(200, 95)),
        onPressed: _guardando ? null : _submit,
        child: _guardando
            ? const CircularProgressIndicator()
            : const Text('Guardar')
        //onPressed: () => log(_prefs.ipCameraId.toString()),
        );
  }

  void _submit() async {
    setState(() => _guardando = true);
    _saveParameters();

    FocusScope.of(context).unfocus();
  }

  void _saveParameters() async {
    _prefs.accesoVehicular = _accesoVehicular ? 1 : 0;
    _prefs.accesoPeatonal = _accesoPeatonal ? 1 : 0;
    _prefs.accesoFacial = _accesoFacial ? 1 : 0;
    //_prefs.accesoTag = _accesoTag ? 1 : 0;

    openAlertBoxSimple(
      context,
      'Parámetros Guardados',
      'Los parámetros han sido guardados',
    );

    setState(() => _guardando = false);
  }

  void _loadValues() {
    _accesoVehicular = _prefs.accesoVehicular == 1;
    _accesoPeatonal = _prefs.accesoPeatonal == 1;
    _accesoFacial = _prefs.accesoFacial == 1;
    //_accesoTag = _prefs.accesoTag == 1;
  }
}
