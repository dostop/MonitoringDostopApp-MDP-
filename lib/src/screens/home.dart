import 'dart:async';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../services/auth_services.dart';
import '../services/visitService.dart';
import '../ui/dialogs.dart';
import '../utils/user_preferences.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final checkService = AuthService();
  final _prefs = UserPreferences();
  final _txtPassCtrl = TextEditingController();
  final _visitService = VisitService();

  // Entrada vehicular
  String _nameEntradaVehicular = '';
  String _fotoEntradaVehicular = '';
  String _statusEntradaVehicular = '';
  String _domicilioEntradaVehicular = '';
  Timer? _vehicularAcceso;

  // Salida vehicular
  String _nameSalidaVehicular = '';
  String _fotoSalidaVehicular = '';
  String _domicilioSalidaVehicular = '';
  Timer? _vehicularSalida;

  // Entrada peatonal
  String _nameEntradaPeatonal = '';
  String _fotoEntradaPeatonal = '';
  String _statusEntradaPeatonal = '';
  String _domicilioEntradaPeatonal = '';
  Timer? _peatonalAcceso;

  // Salida peatonal
  String _nameSalidaPeatonal = '';
  String _fotoSalidaPeatonal = '';
  String _domicilioSalidaPeatonal = '';
  Timer? _peatonalSalida;

  // Entrada facial
  String _nameEntradaFacial = '';
  String _fotoEntradaFacial = '';
  String _statusEntradaFacial = '';
  String _domicilioEntradaFacial = '';
  Timer? _facialAcceso;

  // Salida facial
  String _nameSalidaFacial = '';
  String _fotoSalidaFacial = '';
  String _domicilioSalidaFacial = '';
  Timer? _facialSalida;

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

  void _ultimaVisitaVehicular() {
    _vehicularAcceso = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) return;
      final resp = await _visitService.ultimaVisitaVehicular();
      if (!resp.containsKey('statusCode')) {
        setState(() {
          if (resp['data'].isEmpty) {
            _nameEntradaVehicular = '';
            _fotoEntradaVehicular = '';
            _statusEntradaVehicular = '';
            _domicilioEntradaVehicular = '';
          } else {
            _nameEntradaVehicular = resp['data']['name'];
            _statusEntradaVehicular = resp['data']['status'] ?? 'Esperando respuesta';
            _fotoEntradaVehicular = resp['data']['rostro'] ?? '';
            _domicilioEntradaVehicular = resp['data']['address'];
          }
        });
      }
    });
  }

  void _ultimaSalidaVehicular() {
    _vehicularSalida = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) return;
      final resp = await _visitService.ultimaSalidaVehicular();
      if (!resp.containsKey('statusCode')) {
        setState(() {
          if (resp['data'].isEmpty) {
            _nameSalidaVehicular = '';
            _fotoSalidaVehicular = '';
            _domicilioSalidaVehicular = '';
          } else {
            _nameSalidaVehicular = resp['data']['name'];
            _fotoSalidaVehicular = resp['data']['rostro'] ?? '';
            _domicilioSalidaVehicular = resp['data']['address'];
          }
        });
      }
    });
  }

  void _ultimaVisitaPeatonal() {
    _peatonalAcceso = Timer.periodic(const Duration(milliseconds: 2500), (timer) async {
      if (!mounted) return;
      final resp = await _visitService.ultimaVisitaPeatonal();
      if (!resp.containsKey('statusCode')) {
        setState(() {
          if (resp['data'].isEmpty) {
            _nameEntradaPeatonal = '';
            _fotoEntradaPeatonal = '';
            _statusEntradaPeatonal = '';
            _domicilioEntradaPeatonal = '';
          } else {
            _nameEntradaPeatonal = resp['data']['name'];
            _statusEntradaPeatonal = resp['data']['status'] ?? 'Esperando respuesta';
            _fotoEntradaPeatonal = resp['data']['rostro'] ?? '';
            _domicilioEntradaPeatonal = resp['data']['address'];
          }
        });
      }
    });
  }

  void _ultimaSalidaPeatonal() {
    _peatonalSalida = Timer.periodic(const Duration(milliseconds: 2500), (timer) async {
      if (!mounted) return;
      final resp = await _visitService.ultimaSalidaPeatonal();
      if (!resp.containsKey('statusCode')) {
        setState(() {
          if (resp['data'].isEmpty) {
            _nameSalidaPeatonal = '';
            _fotoSalidaPeatonal = '';
            _domicilioSalidaPeatonal = '';
          } else {
            _nameSalidaPeatonal = resp['data']['name'];
            _fotoSalidaPeatonal = resp['data']['rostro'] ?? '';
            _domicilioSalidaPeatonal = resp['data']['address'];
          }
        });
      }
    });
  }

  void _ultimaVisitaFacial() {
    _facialAcceso = Timer.periodic(const Duration(milliseconds: 2250), (timer) async {
      if (!mounted) return;
      final resp = await _visitService.ultimaVisitafacial();
      if (!resp.containsKey('statusCode')) {
        setState(() {
          if (resp['data'].isEmpty) {
            _nameEntradaFacial = '';
            _fotoEntradaFacial = '';
            _statusEntradaFacial = '';
            _domicilioEntradaFacial = '';
          } else {
            _nameEntradaFacial = resp['data']['name'];
            _statusEntradaFacial = resp['data']['status'] ?? 'Esperando respuesta';
            _fotoEntradaFacial = resp['data']['img'] ?? '';
            _domicilioEntradaFacial = resp['data']['address'];
          }
        });
      }
    });
  }

  void _ultimaSalidaFacial() {
    _facialSalida = Timer.periodic(const Duration(milliseconds: 2250), (timer) async {
      if (!mounted) return;
      final resp = await _visitService.ultimaSalidaFacial();
      if (!resp.containsKey('statusCode')) {
        setState(() {
          if (resp['data'].isEmpty) {
            _nameSalidaFacial = '';
            _fotoSalidaFacial = '';
            _domicilioSalidaFacial = '';
          } else {
            _nameSalidaFacial = resp['data']['name'];
            _fotoSalidaFacial = resp['data']['img'] ?? '';
            _domicilioSalidaFacial = resp['data']['address'];
          }
        });
      }
    });
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
                Icons.settings,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: _settings,
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 900;

            // Pantalla chica: scroll vertical sin Expanded
            if (isSmallScreen) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: _buildAccessWidgetsNoExpanded(),
                ),
              );
            }

            // Pantalla grande: fila estirada en alto con Expanded
            return SizedBox(
              height: constraints.maxHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildAccessWidgetsExpanded(),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildAccessWidgetsExpanded() {
    return [
      if (_prefs.accesoVehicular == 1)
        Expanded(
          child: InfoAccessCard(
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
        ),
      if (_prefs.accesoPeatonal == 1)
        Expanded(
          child: InfoAccessCard(
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
        ),
      if (_prefs.accesoFacial == 1)
        Expanded(
          child: InfoAccessCard(
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
        ),
    ];
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
    _vehicularAcceso?.cancel();
    _vehicularSalida?.cancel();
    _peatonalAcceso?.cancel();
    _peatonalSalida?.cancel();
    _facialAcceso?.cancel();
    _facialSalida?.cancel();
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
