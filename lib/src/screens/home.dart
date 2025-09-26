import 'dart:async';
import 'dart:developer';

import 'package:flutter_dostop_monitoreo/src/services/auth_services.dart';
import 'package:flutter_dostop_monitoreo/src/services/visitService.dart';
import 'package:flutter_dostop_monitoreo/src/ui/dialogs.dart';
import 'package:flutter_dostop_monitoreo/src/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dostop_monitoreo/src/utils/utils.dart';

import '../../main.dart';

const Map<String, String> _noCacheImageHeaders = <String, String>{
  'Cache-Control': 'no-cache, no-store, must-revalidate',
  'Pragma': 'no-cache',
  'Expires': '0',
};

String bustUrl(String url, {String? versionOrUpdatedAt}) {
  final String trimmed = versionOrUpdatedAt?.trim() ?? '';
  final String sep = url.contains('?') ? '&' : '?';
  final String stamp = trimmed.isNotEmpty
      ? trimmed
      : DateTime.now().microsecondsSinceEpoch.toString();
  final String busted = '$url${sep}v=$stamp';
  log('[VisitService] img bust: url=$busted');
  return busted;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final checkService = AuthService();
  final _prefs = UserPreferences();
  final _txtPassCtrl = TextEditingController();
  final _visitService = VisitService();
  Map<String, dynamic> jsonData = {};
  bool _isVisible = true;
  //entrada vehicular
  String _nameEntradaVehicular = '';
  String _fotoEntradaVehicular = '';
  String _fotoEntradaVehicularVersion = '';
  String _statusEntradaVehicular = '';
  String _domicilioEntradaVehicular = '';
  Timer? _vehicularAcceso;
  //String _tipoEntradaVehicular = '';

  //salida vehicular
  String _nameSalidaVehicular = '';
  String _fotoSalidaVehicular = '';
  String _fotoSalidaVehicularVersion = '';
  String _domicilioSalidaVehicular = '';
  Timer? _vehicularSalida;
  //String _tipoSalidaVehicular = '';

  //Entrada peatonal
  String _nameEntradaPeatonal = '';
  String _fotoEntradaPeatonal = '';
  String _fotoEntradaPeatonalVersion = '';
  String _statusEntradaPeatonal = '';
  String _domicilioEntradaPeatonal = '';
  Timer? _peatonalAcceso;
  //String _tipoEntradaPeatonal = '';

  //salida peatonal
  String _nameSalidaPeatonal = '';
  String _fotoSalidaPeatonal = '';
  String _fotoSalidaPeatonalVersion = '';
  String _domicilioSalidaPeatonal = '';
  Timer? _peatonalSalida;
  //String _tipoSalidaPeatonal = '';

  //entrada facial
  String _nameEntradaFacial = '';
  String _fotoEntradaFacial = '';
  String _fotoEntradaFacialVersion = '';
  String _statusEntradaFacial = '';
  String _domicilioEntradaFacial = '';
  Timer? _facialAcceso;
  //String _tipoEntradaFacial = '';

  //salida facial
  String _nameSalidaFacial = '';
  String _fotoSalidaFacial = '';
  String _fotoSalidaFacialVersion = '';
  String _domicilioSalidaFacial = '';
  Timer? _facialSalida;
  //String _tipoSalidaFacial = '';
  //entrada tag
  //salida tag

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkStatusFracc();
    unawaited(_refreshAll(forceRefresh: true));
    _startAutoRefresh();
  }

  Future<void> _ultimaVisitaVehicular({bool forceRefresh = false}) async {
    final Map<String, dynamic> resp =
        await _visitService.ultimaVisitaVehicular(forceRefresh: forceRefresh);
    if (!mounted) return;
    if (resp.containsKey('statusCode')) {
      log('error de consulta acceso vehicular');
      return;
    }
    final dynamic data = resp['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      setState(() {
        _nameEntradaVehicular = data['name'] ?? '';
        _statusEntradaVehicular = data['status'] == null
            ? 'Esperando respuesta'
            : data['status'];
        _fotoEntradaVehicular = data['rostro'] == null ? '' : data['rostro'];
        _fotoEntradaVehicularVersion = _extractVersion(data);
        _domicilioEntradaVehicular = data['address'] ?? '';
      });
    } else {
      setState(() {
        _nameEntradaVehicular = '';
        _fotoEntradaVehicular = '';
        _fotoEntradaVehicularVersion = '';
        _statusEntradaVehicular = '';
        _domicilioEntradaVehicular = '';
      });
    }
  }

  Future<void> _ultimaSalidaVehicular({bool forceRefresh = false}) async {
    final Map<String, dynamic> resp =
        await _visitService.ultimaSalidaVehicular(forceRefresh: forceRefresh);
    if (!mounted) return;
    if (resp.containsKey('statusCode')) {
      log('error de consulta salida vehicular');
      return;
    }
    final dynamic data = resp['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      setState(() {
        _nameSalidaVehicular = data['name'] ?? '';
        _fotoSalidaVehicular = data['rostro'] == null ? '' : data['rostro'];
        _fotoSalidaVehicularVersion = _extractVersion(data);
        _domicilioSalidaVehicular = data['address'] ?? '';
      });
    } else {
      setState(() {
        _nameSalidaVehicular = '';
        _fotoSalidaVehicular = '';
        _fotoSalidaVehicularVersion = '';
        _domicilioSalidaVehicular = '';
      });
    }
  }

  Future<void> _ultimaVisitaPeatonal({bool forceRefresh = false}) async {
    final Map<String, dynamic> resp =
        await _visitService.ultimaVisitaPeatonal(forceRefresh: forceRefresh);
    if (!mounted) return;
    if (resp.containsKey('statusCode')) {
      log('error de consulta acceso peatonal');
      return;
    }
    final dynamic data = resp['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      setState(() {
        _nameEntradaPeatonal = data['name'] ?? '';
        _statusEntradaPeatonal = data['status'] == null
            ? 'Esperando respuesta'
            : data['status'];
        _fotoEntradaPeatonal = data['rostro'] == null ? '' : data['rostro'];
        _fotoEntradaPeatonalVersion = _extractVersion(data);
        _domicilioEntradaPeatonal = data['address'] ?? '';
      });
    } else {
      setState(() {
        _nameEntradaPeatonal = '';
        _fotoEntradaPeatonal = '';
        _fotoEntradaPeatonalVersion = '';
        _statusEntradaPeatonal = '';
        _domicilioEntradaPeatonal = '';
      });
    }
  }

  Future<void> _ultimaSalidaPeatonal({bool forceRefresh = false}) async {
    final Map<String, dynamic> resp =
        await _visitService.ultimaSalidaPeatonal(forceRefresh: forceRefresh);
    if (!mounted) return;
    if (resp.containsKey('statusCode')) {
      log('error de consulta salia peatonal');
      return;
    }
    final dynamic data = resp['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      setState(() {
        _nameSalidaPeatonal = data['name'] ?? '';
        _fotoSalidaPeatonal = data['rostro'] == null ? '' : data['rostro'];
        _fotoSalidaPeatonalVersion = _extractVersion(data);
        _domicilioSalidaPeatonal = data['address'] ?? '';
      });
    } else {
      setState(() {
        _nameSalidaPeatonal = '';
        _fotoSalidaPeatonal = '';
        _fotoSalidaPeatonalVersion = '';
        _domicilioSalidaPeatonal = '';
      });
    }
  }

  Future<void> _ultimaVisitaFacial({bool forceRefresh = false}) async {
    final Map<String, dynamic> resp =
        await _visitService.ultimaVisitafacial(forceRefresh: forceRefresh);
    if (!mounted) return;
    if (resp.containsKey('statusCode')) {
      log('error de consulta acceso facial');
      return;
    }
    final dynamic data = resp['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      setState(() {
        _nameEntradaFacial = data['name'] ?? '';
        _statusEntradaFacial = data['status'] == null
            ? 'Esperando respuesta'
            : data['status'];
        _fotoEntradaFacial = data['img'] == null ? '' : data['img'];
        _fotoEntradaFacialVersion = _extractVersion(data);
        _domicilioEntradaFacial = data['address'] ?? '';
      });
    } else {
      setState(() {
        _nameEntradaFacial = '';
        _fotoEntradaFacial = '';
        _fotoEntradaFacialVersion = '';
        _statusEntradaFacial = '';
        _domicilioEntradaFacial = '';
      });
    }
  }

  Future<void> _ultimaSalidaFacial({bool forceRefresh = false}) async {
    final Map<String, dynamic> resp =
        await _visitService.ultimaSalidaFacial(forceRefresh: forceRefresh);
    if (!mounted) return;
    if (resp.containsKey('statusCode')) {
      log('error de consulta salida facial');
      return;
    }
    final dynamic data = resp['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      setState(() {
        _nameSalidaFacial = data['name'] ?? '';
        _fotoSalidaFacial = data['img'] == null ? '' : data['img'];
        _fotoSalidaFacialVersion = _extractVersion(data);
        _domicilioSalidaFacial = data['address'] ?? '';
      });
    } else {
      setState(() {
        _nameSalidaFacial = '';
        _fotoSalidaFacial = '';
        _fotoSalidaFacialVersion = '';
        _domicilioSalidaFacial = '';
      });
    }
  }

  String _extractVersion(Map<String, dynamic> data) {
    final dynamic updatedAt = data['updatedAt'] ??
        data['updated_at'] ??
        data['lastUpdated'] ??
        data['last_updated'] ??
        data['updated'] ??
        data['version'];
    return updatedAt == null ? '' : updatedAt.toString();
  }

  Duration get _refreshInterval =>
      Duration(seconds: _prefs.refreshIntervalSeconds.clamp(5, 60));

  Future<void> _refreshAll({bool forceRefresh = false}) async {
    final List<Future<void>> futures = <Future<void>>[];
    if (_prefs.accesoVehicular == 1) {
      futures
        ..add(_ultimaVisitaVehicular(forceRefresh: forceRefresh))
        ..add(_ultimaSalidaVehicular(forceRefresh: forceRefresh));
    }
    if (_prefs.accesoPeatonal == 1) {
      futures
        ..add(_ultimaVisitaPeatonal(forceRefresh: forceRefresh))
        ..add(_ultimaSalidaPeatonal(forceRefresh: forceRefresh));
    }
    if (_prefs.accesoFacial == 1) {
      futures
        ..add(_ultimaVisitaFacial(forceRefresh: forceRefresh))
        ..add(_ultimaSalidaFacial(forceRefresh: forceRefresh));
    }
    if (futures.isEmpty) {
      return;
    }
    await Future.wait(futures);
  }

  void _startAutoRefresh() {
    _cancelTimers();
    if (!_isVisible) {
      return;
    }
    final Duration interval = _refreshInterval;
    if (_prefs.accesoVehicular == 1) {
      _vehicularAcceso = _createTimer(interval, () => _ultimaVisitaVehicular());
      _vehicularSalida = _createTimer(interval, () => _ultimaSalidaVehicular());
    }
    if (_prefs.accesoPeatonal == 1) {
      _peatonalAcceso = _createTimer(interval, () => _ultimaVisitaPeatonal());
      _peatonalSalida = _createTimer(interval, () => _ultimaSalidaPeatonal());
    }
    if (_prefs.accesoFacial == 1) {
      _facialAcceso = _createTimer(interval, () => _ultimaVisitaFacial());
      _facialSalida = _createTimer(interval, () => _ultimaSalidaFacial());
    }
  }

  void _cancelTimers() {
    _vehicularAcceso?.cancel();
    _vehicularAcceso = null;
    _vehicularSalida?.cancel();
    _vehicularSalida = null;
    _peatonalAcceso?.cancel();
    _peatonalAcceso = null;
    _peatonalSalida?.cancel();
    _peatonalSalida = null;
    _facialAcceso?.cancel();
    _facialAcceso = null;
    _facialSalida?.cancel();
    _facialSalida = null;
  }

  Timer _createTimer(Duration interval, Future<void> Function() callback) {
    return Timer.periodic(interval, (Timer timer) {
      if (!mounted || !_isVisible) {
        return;
      }
      unawaited(callback());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bool visible = state == AppLifecycleState.resumed;
    if (_isVisible == visible) {
      return;
    }
    _isVisible = visible;
    if (visible) {
      unawaited(_refreshAll());
      _startAutoRefresh();
    } else {
      _cancelTimers();
    }
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
                Icons.refresh,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () => _refreshAll(forceRefresh: true),
            ),
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
                      _domicilioSalidaVehicular,
                      fotoEntradaVersion: _fotoEntradaVehicularVersion,
                      fotoSalidaVersion: _fotoSalidaVehicularVersion
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
                fotoEntradaVersion: _fotoEntradaPeatonalVersion,
                fotoSalidaVersion: _fotoSalidaPeatonalVersion,
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
                fotoEntradaVersion: _fotoEntradaFacialVersion,
                fotoSalidaVersion: _fotoSalidaFacialVersion,
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
    {
    String fotoEntradaVersion = '',
    String fotoSalidaVersion = '',
  }) {
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
                          bustUrl(
                            fotoEntrada,
                            versionOrUpdatedAt: fotoEntradaVersion.isNotEmpty
                                ? fotoEntradaVersion
                                : null,
                          ),
                          gaplessPlayback: true,
                          headers: _noCacheImageHeaders,
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
                          bustUrl(
                            fotoSalida,
                            versionOrUpdatedAt: fotoSalidaVersion.isNotEmpty
                                ? fotoSalidaVersion
                                : null,
                          ),
                          gaplessPlayback: true,
                          headers: _noCacheImageHeaders,
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
    WidgetsBinding.instance.removeObserver(this);
    _cancelTimers();
    _txtPassCtrl.dispose();
    super.dispose();
  }
}
