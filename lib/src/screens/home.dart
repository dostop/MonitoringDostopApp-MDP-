import 'dart:async';
import 'dart:developer';

import 'package:flutter_dostop_monitoreo/src/services/auth_services.dart';
import 'package:flutter_dostop_monitoreo/src/services/visitService.dart';
import 'package:flutter_dostop_monitoreo/src/ui/dialogs.dart';
import 'package:flutter_dostop_monitoreo/src/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final checkService = AuthService();
  final _prefs = UserPreferences();
  final _txtPassCtrl = TextEditingController();
  final _visitService = VisitService();
  Map<String, dynamic> jsonData = {};
  //entrada vehicular
  String _nameEntradaVehicular = '';
  String _fotoEntradaVehicular = '';
  String _statusEntradaVehicular = '';
  String _domicilioEntradaVehicular = '';
  Timer? _vehicularAcceso;
  //String _tipoEntradaVehicular = '';

  //salida vehicular
  String _nameSalidaVehicular = '';
  String _fotoSalidaVehicular = '';
  String _domicilioSalidaVehicular = '';
  Timer? _vehicularSalida;
  //String _tipoSalidaVehicular = '';

  //Entrada peatonal
  String _nameEntradaPeatonal = '';
  String _fotoEntradaPeatonal = '';
  String _statusEntradaPeatonal = '';
  String _domicilioEntradaPeatonal = '';
  Timer? _peatonalAcceso;
  //String _tipoEntradaPeatonal = '';

  //salida peatonal
  String _nameSalidaPeatonal = '';
  String _fotoSalidaPeatonal = '';
  String _domicilioSalidaPeatonal = '';
  Timer? _peatonalSalida;
  //String _tipoSalidaPeatonal = '';

  //entrada facial
  String _nameEntradaFacial = '';
  String _fotoEntradaFacial = '';
  String _statusEntradaFacial = '';
  String _domicilioEntradaFacial = '';
  Timer? _facialAcceso;
  //String _tipoEntradaFacial = '';

  //salida facial
  String _nameSalidaFacial = '';
  String _fotoSalidaFacial = '';
  String _domicilioSalidaFacial = '';
  Timer? _facialSalida;
  //String _tipoSalidaFacial = '';
  //entrada tag
  //salida tag

  @override
  void initState() {
    super.initState();
    checkStatusFracc();
    if (_prefs.accesoVehicular == 1) {
      _ultimaVisitaVehicular();
      _ultimaSalidaVehicular();
    }
    if (_prefs.accesoPeatonal == 1) {
      _ultimaVisitaPeatonal();
      _ultimaSalidaPeatonal();
    }
    if (_prefs.accesoFacial == 1) {
      _ultimaVisitaFacial();
      _ultimaSalidaFacial();
    }
  }

  void _ultimaVisitaVehicular() async {
    _vehicularAcceso =
        Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (mounted) {
        log('ejecutando');
        Map<String, dynamic> resp = await _visitService.ultimaVisitaVehicular();
        if (resp.containsKey('statusCode')) {
          log('error de consulta acceso vehicular');
        } else {
          if (resp['data'].isEmpty) {
            setState(() {
              _nameEntradaVehicular = '';
              _fotoEntradaVehicular = '';
              _statusEntradaVehicular = '';
              _domicilioEntradaVehicular = '';
              //_tipoEntradaVehicular = '';
            });
          } else {
            setState(() {
              _nameEntradaVehicular = resp['data']['name'];
              _statusEntradaVehicular = resp['data']['status'] == null
                  ? 'Esperando respuesta'
                  : resp['data']['status'];
              _fotoEntradaVehicular =
                  resp['data']['rostro'] == null ? '' : resp['data']['rostro'];
              _domicilioEntradaVehicular = resp['data']['address'];
              // _tipoEntradaVehicular = resp['data']['typeVisit'];
            });
          }
        }
        setState(() {});
      }
    });
  }

  void _ultimaSalidaVehicular() async {
    _vehicularSalida =
        Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      if (mounted) {
        Map<String, dynamic> resp = await _visitService.ultimaSalidaVehicular();
        if (resp.containsKey('statusCode')) {
          log('error de consulta salida vehicular');
        } else {
          if (resp['data'].isEmpty) {
            setState(() {
              _nameSalidaVehicular = '';
              _fotoSalidaVehicular = '';
              _domicilioSalidaVehicular = '';
              //_tipoSalidaVehicular = '';
            });
          } else {
            setState(() {
              _nameSalidaVehicular = resp['data']['name'];
              _fotoSalidaVehicular =
                  resp['data']['rostro'] == null ? '' : resp['data']['rostro'];
              _domicilioSalidaVehicular = resp['data']['address'];
              //_tipoSalidaVehicular = resp['data']['typeVisit'];
            });
          }
        }
        setState(() {});
      }
    });
  }

  void _ultimaVisitaPeatonal() {
    _peatonalAcceso =
        Timer.periodic(const Duration(milliseconds: 2500), (Timer timer) async {
      if (mounted) {
        log('ejecutando');
        Map<String, dynamic> resp = await _visitService.ultimaVisitaPeatonal();
        if (resp.containsKey('statusCode')) {
          log('error de consulta acceso peatonal');
        } else {
          if (resp['data'].isEmpty) {
            setState(() {
              _nameEntradaPeatonal = '';
              _fotoEntradaPeatonal = '';
              _statusEntradaPeatonal = '';
              _domicilioEntradaPeatonal = '';
              //_tipoEntradaPeatonal = '';
            });
          } else {
            setState(() {
              _nameEntradaPeatonal = resp['data']['name'];
              _statusEntradaPeatonal = resp['data']['status'] == null
                  ? 'Esperando respuesta'
                  : resp['data']['status'];
              _fotoEntradaPeatonal =
                  resp['data']['rostro'] == null ? '' : resp['data']['rostro'];
              _domicilioEntradaPeatonal = resp['data']['address'];
              //_tipoEntradaPeatonal = resp['data']['typeVisit'];
            });
          }
        }
        setState(() {});
      }
    });
  }

  void _ultimaSalidaPeatonal() {
    _peatonalSalida =
        Timer.periodic(const Duration(milliseconds: 2500), (Timer timer) async {
      if (mounted) {
        Map<String, dynamic> resp = await _visitService.ultimaSalidaPeatonal();
        if (resp.containsKey('statusCode')) {
          log('error de consulta salia peatonal');
        } else {
          if (resp['data'].isEmpty) {
            setState(() {
              _nameSalidaPeatonal = '';
              _fotoSalidaPeatonal = '';
              _domicilioSalidaPeatonal = '';
              //_tipoSalidaPeatonal = '';
            });
          } else {
            setState(() {
              _nameSalidaPeatonal = resp['data']['name'];
              _fotoSalidaPeatonal =
                  resp['data']['rostro'] == null ? '' : resp['data']['rostro'];
              _domicilioSalidaPeatonal = resp['data']['address'];
              //_tipoSalidaPeatonal = resp['data']['typeVisit'];
            });
          }
        }
        setState(() {});
      }
    });
  }

  void _ultimaVisitaFacial() {
    _facialAcceso =
        Timer.periodic(const Duration(milliseconds: 2250), (Timer timer) async {
      Map<String, dynamic> resp = await _visitService.ultimaVisitafacial();
      if (resp.containsKey('statusCode')) {
        log('error de consulta acceso facial');
      } else {
        if (resp['data'].isEmpty) {
          setState(() {
            _nameEntradaFacial = '';
            _fotoEntradaFacial = '';
            _statusEntradaFacial = '';
            _domicilioEntradaFacial = '';
            //_tipoEntradaFacial = '';
          });
        } else {
          setState(() {
            _nameEntradaFacial = resp['data']['name'];
            _statusEntradaFacial = resp['data']['status'] == null
                ? 'Esperando respuesta'
                : resp['data']['status'];
            _fotoEntradaFacial =
                resp['data']['img'] == null ? '' : resp['data']['img'];
            _domicilioEntradaFacial = resp['data']['address'];
            //_tipoEntradaFacial = resp['data']['typeVisit'];
          });
        }
      }
    });
  }

  void _ultimaSalidaFacial() {
    _facialSalida =
        Timer.periodic(const Duration(milliseconds: 2250), (Timer timer) async {
      Map<String, dynamic> resp = await _visitService.ultimaSalidaFacial();
      if (resp.containsKey('statusCode')) {
        log('error de consulta salida facial');
      } else {
        if (resp['data'].isEmpty) {
          setState(() {
            _nameSalidaFacial = '';
            _fotoSalidaFacial = '';
            _domicilioSalidaFacial = '';
            //_tipoSalidaFacial = '';
          });
        } else {
          setState(() {
            _nameSalidaFacial = resp['data']['name'];
            _fotoSalidaFacial =
                resp['data']['img'] == null ? '' : resp['data']['img'];
            _domicilioSalidaFacial = resp['data']['address'];
            //_tipoSalidaFacial = resp['data']['typeVisit'];
          });
        }
      }
    });
  }

  void checkStatusFracc() async {
    String status = await checkService.statusFracc();
    if (status == 'Suspendido' || status == 'Cancelado' || status == '403') {
      openAlertBoxSimple(
          context,
          'Lamentablemente el servicio de Dostop ha sido suspendido.\nPor favor, contacta con la administración',
          '',
          visibleContent: false,
          showButton: false);

      Future.delayed(const Duration(seconds: 10), () async {
        //checkService.deletePlayerIdOS();
        checkService.logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: MediaQuery.of(context).size.width * 0.2,
          actions: [
            IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_round,
                  size: MediaQuery.of(context).size.height * 0.03,
                ),
                onPressed: MyApp.of(context)!.changeTheme),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () {
                _settings();
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          ],
        ),
        body: Row(
          children: [
            Visibility(
              visible: _prefs.accesoVehicular == 1,
              child: Expanded(
                  child: _infoContainer(
                      'Entrada vehicular',
                      _fotoEntradaVehicular,
                      _nameEntradaVehicular,
                      _domicilioEntradaVehicular,
                      _statusEntradaVehicular,
                      //'Aceptada',
                      //_tipoEntradaVehicular,
                      'Salida vehicular',
                      _fotoSalidaVehicular,
                      _nameSalidaVehicular,
                      _domicilioSalidaVehicular
                      //_tipoSalidaVehicular
                      )),
            ),
            Visibility(
              visible: _prefs.accesoPeatonal == 1,
              child: Expanded(
                  child: _infoContainer(
                'Entrada peatonal',
                _fotoEntradaPeatonal,
                _nameEntradaPeatonal,
                _domicilioEntradaPeatonal,
                _statusEntradaPeatonal,
                //_tipoEntradaPeatonal,
                'Salida peatonal',
                _fotoSalidaPeatonal,
                _nameSalidaPeatonal,
                _domicilioSalidaPeatonal,
                // _tipoSalidaPeatonal
              )),
            ),
            Visibility(
              visible: _prefs.accesoFacial == 1,
              child: Expanded(
                  child: _infoContainer(
                'Entrada facial',
                _fotoEntradaFacial,
                _nameEntradaFacial,
                _domicilioEntradaFacial,
                _statusEntradaFacial,
                //_tipoEntradaFacial,
                'Salida facial',
                _fotoSalidaFacial,
                _nameSalidaFacial,
                _domicilioSalidaFacial,
                //_tipoSalidaFacial
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoContainer(
    String tituloAcceso,
    String fotoEntrada,
    String visitanteEntrada,
    String domicilioEntrada,
    String statusEntrada,
    //String tipoEntrada,
    String tituloSalida,
    String fotoSalida,
    String visitanteSalida,
    String domicilioSalida,
    //String tipoSalida,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: _prefs.themeMode == 'Dark' ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: statusEntrada == 'Aceptada'
                  ? mainGreenColor
                  : statusEntrada == 'Rechazada'
                      ? mainRedColor
                      : statusEntrada == 'Esperando respuesta'
                          ? Colors.orange
                          : statusEntrada == 'Sin respuesta'
                              ? Colors.orange
                              : Colors.transparent,
            ),
            width: double.infinity,
            child: Column(
              children: [
                _txtFormat(tituloAcceso),
                const SizedBox(height: 10),
                fotoEntrada == ''
                    ? Container()
                    : Flexible(
                        child: Image.network(
                          fotoEntrada,
                          fit: BoxFit
                              .contain, // Ajusta la imagen al espacio disponible
                        ),
                      ),
                fotoEntrada == ''
                    ? const SizedBox(height: 100)
                    : const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _txtFormat('Visitante: '),
                    Text(visitanteEntrada),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_txtFormat('Domicilio: '), Text(domicilioEntrada)],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_txtFormat('Status: '), Text(statusEntrada)],
                  /* children: [
                    _txtFormat('Status: '),
                    Container(
                      padding: EdgeInsets.all(5),
                      color: mainGreenColor,
                      child: Text('Aceptada'),
                    )
                  ], */
                ),
                const SizedBox(height: 10),
                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_txtFormat('Tipo: '), Text(tipoEntrada)],
                ) */
              ],
            ),
          )),
          const SizedBox(height: 10),
          Divider(
            thickness: 5,
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Container(
            width: double.infinity,
            child: Column(
              children: [
                _txtFormat(tituloSalida),
                const SizedBox(height: 10),
                fotoSalida == ''
                    ? Container()
                    : Flexible(
                        child: Image.network(
                          fotoSalida,
                          fit: BoxFit
                              .contain, // Ajusta la imagen al espacio disponible
                        ),
                      ),
                fotoSalida == ''
                    ? const SizedBox(height: 100)
                    : const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _txtFormat('Visitante: '),
                    Text(visitanteSalida),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_txtFormat('Domicilio: '), Text(domicilioSalida)],
                ),
                const SizedBox(height: 10),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_txtFormat('Tipo: '), Text(tipoSalida)],
                ) */
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _txtFormat(String txt) {
    return Text(
      txt,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  _settings() {
    openAlertBoxField(
        context, _txtPassCtrl, 'Configuración', 'Contraseña', _funtionYes);
  }

  void _funtionYes() {
    if (_txtPassCtrl.text == 'ConfigPass?') {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.pushReplacementNamed(context, 'setting');
      //Navigator.of(context).pushNamed('setting');
    } else {
      openDialogSimple(context, '¡Error al autorizar!',
          'La contraseña es incorrecta', 'Aceptar');
    }
    _txtPassCtrl.clear();
  }

  @override
  void dispose() {
    _vehicularAcceso?.cancel();
    _vehicularSalida?.cancel();
    _peatonalAcceso?.cancel();
    _peatonalSalida?.cancel();
    _facialAcceso?.cancel();
    _facialSalida?.cancel();
    super.dispose();
  }
}
