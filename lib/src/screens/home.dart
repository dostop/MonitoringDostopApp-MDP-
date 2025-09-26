import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../services/auth_services.dart';
import '../services/visitService.dart';
import '../ui/dialogs.dart';
import '../utils/user_preferences.dart';
import '../utils/utils.dart';

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

  // Salida vehicular
  String _nameSalidaVehicular = '';
  String _fotoSalidaVehicular = '';
  String _fotoSalidaVehicularVersion = '';
  String _domicilioSalidaVehicular = '';
  Timer? _vehicularSalida;

  // Entrada peatonal
  String _nameEntradaPeatonal = '';
  String _fotoEntradaPeatonal = '';
  String _fotoEntradaPeatonalVersion = '';
  String _statusEntradaPeatonal = '';
  String _domicilioEntradaPeatonal = '';
  Timer? _peatonalAcceso;

  // Salida peatonal
  String _nameSalidaPeatonal = '';
  String _fotoSalidaPeatonal = '';
  String _fotoSalidaPeatonalVersion = '';
  String _domicilioSalidaPeatonal = '';
  Timer? _peatonalSalida;

  // Entrada facial
  String _nameEntradaFacial = '';
  String _fotoEntradaFacial = '';
  String _fotoEntradaFacialVersion = '';
  String _statusEntradaFacial = '';
  String _domicilioEntradaFacial = '';
  Timer? _facialAcceso;

  // Salida facial
  String _nameSalidaFacial = '';
  String _fotoSalidaFacial = '';
  String _fotoSalidaFacialVersion = '';
  String _domicilioSalidaFacial = '';
  Timer? _facialSalida;

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
    final status = await checkService.statusFracc();
    if (status == 'Suspendido' || status == 'Cancelado' || status == '403') {
      openAlertBoxSimple(
        context,
        'Lamentablemente el servicio de Dostop ha sido suspendido.\nPor favor, contacta con la administración',
        '',
        visibleContent: false,
        showButton: false,
      );

      Future.delayed(const Duration(seconds: 10), () {
        checkService.logout();
        Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
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
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: MyApp.of(context)!.changeTheme,
            ),
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
              onPressed: _settings,
            ),
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

  Text _txtFormat(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _buildAccessWidgetsNoExpanded() {
    return [
      if (_prefs.accesoVehicular == 1)
        InfoAccessCard(
          tituloAcceso: 'Entrada vehicular',
          fotoEntrada: _fotoEntradaVehicular,
          visitanteEntrada: _nameEntradaVehicular,
          domicilioEntrada: _domicilioEntradaVehicular,
          statusEntrada: _statusEntradaVehicular,
          tituloSalida: 'Salida vehicular',
          fotoSalida: _fotoSalidaVehicular,
          visitanteSalida: _nameSalidaVehicular,
          domicilioSalida: _domicilioSalidaVehicular,
        ),
      if (_prefs.accesoPeatonal == 1)
        InfoAccessCard(
          tituloAcceso: 'Entrada peatonal',
          fotoEntrada: _fotoEntradaPeatonal,
          visitanteEntrada: _nameEntradaPeatonal,
          domicilioEntrada: _domicilioEntradaPeatonal,
          statusEntrada: _statusEntradaPeatonal,
          tituloSalida: 'Salida peatonal',
          fotoSalida: _fotoSalidaPeatonal,
          visitanteSalida: _nameSalidaPeatonal,
          domicilioSalida: _domicilioSalidaPeatonal,
        ),
      if (_prefs.accesoFacial == 1)
        InfoAccessCard(
          tituloAcceso: 'Entrada facial',
          fotoEntrada: _fotoEntradaFacial,
          visitanteEntrada: _nameEntradaFacial,
          domicilioEntrada: _domicilioEntradaFacial,
          statusEntrada: _statusEntradaFacial,
          tituloSalida: 'Salida facial',
          fotoSalida: _fotoSalidaFacial,
          visitanteSalida: _nameSalidaFacial,
          domicilioSalida: _domicilioSalidaFacial,
        ),
    ];
  }

  void _settings() {
    openAlertBoxField(
      context,
      _txtPassCtrl,
      'Configuración',
      'Contraseña',
      _funtionYes,
    );
  }

  void _funtionYes() {
    if (_txtPassCtrl.text == 'ConfigPass?') {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.pushReplacementNamed(context, 'setting');
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

class InfoAccessCard extends StatelessWidget {
  final String tituloAcceso;
  final String fotoEntrada;
  final String visitanteEntrada;
  final String domicilioEntrada;
  final String statusEntrada;
  final String tituloSalida;
  final String fotoSalida;
  final String visitanteSalida;
  final String domicilioSalida;

  const InfoAccessCard({
    super.key,
    required this.tituloAcceso,
    required this.fotoEntrada,
    required this.visitanteEntrada,
    required this.domicilioEntrada,
    required this.statusEntrada,
    required this.tituloSalida,
    required this.fotoSalida,
    required this.visitanteSalida,
    required this.domicilioSalida,
  });

  Color _statusColor(String status) {
    if (status == 'Aceptada') return mainGreenColor;
    if (status == 'Rechazada') return mainRedColor;
    if (status == 'Esperando respuesta' || status == 'Sin respuesta') {
      return Colors.orange;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: borderColor),
        borderRadius: BorderRadius.circular(30),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Patrón anti-overflow: scroll interno + minHeight para estirarse
          return ScrollConfiguration(
            behavior: const _NoGlowBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _section(
                      context: context,
                      titulo: tituloAcceso,
                      foto: fotoEntrada,
                      visitante: visitanteEntrada,
                      domicilio: domicilioEntrada,
                      status: statusEntrada,
                      isEntrada: true,
                      // Podemos calcular una altura máxima de imagen proporcional al alto disponible
                      maxImageHeight: _computeImageMaxHeight(constraints.maxHeight),
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 5),
                    const SizedBox(height: 12),
                    _section(
                      context: context,
                      titulo: tituloSalida,
                      foto: fotoSalida,
                      visitante: visitanteSalida,
                      domicilio: domicilioSalida,
                      status: '',
                      isEntrada: false,
                      maxImageHeight: _computeImageMaxHeight(constraints.maxHeight),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Calcula una altura máxima “razonable” para la imagen según el alto de la card.
  // En pantallas muy bajas reducimos las imágenes; en pantallas altas las dejamos más grandes.
  double _computeImageMaxHeight(double maxHeight) {
    if (!maxHeight.isFinite) return 220; // fallback seguro
    // Reservamos parte del alto para textos/espaciados; usamos ~30-40% para imagen por sección
    final h = (maxHeight * 0.35).clamp(120.0, 280.0);
    return h;
  }
// === Foto con altura fija + loader + error ===
  Widget _photoBox(String? url) {
    const double kPhotoHeight = 220;
    final border = BorderRadius.circular(12);

    Widget placeholder([String msg = 'Sin imagen']) => Container(
      height: kPhotoHeight,
      decoration: BoxDecoration(
        color: Color(0xFF1E2230),
        borderRadius: border,
        border: Border.all(color: Color(0x334C566A)),
      ),
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_outlined, size: 36),
          SizedBox(height: 8),
          Text('Sin imagen', style: TextStyle(fontSize: 12)),
        ],
      ),
    );

    if (url == null || url.isEmpty) return placeholder();

    return ClipRRect(
      borderRadius: border,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: kPhotoHeight,
          maxHeight: kPhotoHeight,
        ),
        child: Image.network(
          url,
          fit: BoxFit.cover,           // usa BoxFit.contain si no quieres recortar
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          cacheWidth: 1000,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            final v = progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                : null;
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(color: Color(0xFF1E2230)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(value: v),
                ),
              ],
            );
          },
          errorBuilder: (ctx, err, st) => placeholder('No se pudo cargar'),
        ),
      ),
    );
  }

  Widget _section({
    required BuildContext context,
    required String titulo,
    required String foto,
    required String visitante,
    required String domicilio,
    required String status,
    required bool isEntrada,
    required double maxImageHeight,
  }) {
    final bg = isEntrada ? _statusColor(status) : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Imagen respondiendo a la altura disponible; si no hay foto, dejamos un espacio pequeño
          if (foto.isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxImageHeight),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  foto,
                  fit: BoxFit.contain,
                  // Opcional: placeholder mientras carga
                  // loadingBuilder: (ctx, child, progress) => progress == null
                  //     ? child
                  //     : const SizedBox(
                  //         height: 60, child: Center(child: CircularProgressIndicator())),
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 60,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 16),

          const SizedBox(height: 10),
          _infoRow('Visitante', visitante),
          const SizedBox(height: 6),
          _infoRow('Domicilio', domicilio),
          if (isEntrada) ...[
            const SizedBox(height: 6),
            _infoRow('Status', status),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Flexible(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

// Evita el glow azul en scroll de algunos dispositivos
class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
