# flutter_dostop_monitoreo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)


## Arquitectura y estructura del proyecto
La aplicación sigue la estructura estándar de un proyecto Flutter:

```
lib/
 └── main.dart        # Punto de entrada de la aplicación. Define tema, home y lógica del contador.
assets/              # Directorio reservado para recursos gráficos/sonoros (actualmente vacío).
fonts/               # Directorio para tipografías personalizadas (actualmente vacío).
windows/             # Código específico generado para la plataforma Windows.
```

### Flujo interno
1. `main.dart` ejecuta `runApp` y monta el widget raíz `MyApp`.
2. `MyApp` configura `MaterialApp`, define un `ThemeData` y establece como pantalla de inicio a `MyHomePage`.
3. `MyHomePage` es un `StatefulWidget` que contiene el estado `_counter` y la lógica para incrementarlo.
4. `_MyHomePageState` renderiza la UI (`Scaffold`, `AppBar`, `FloatingActionButton`) y actualiza la vista cada vez que se llama a `_incrementCounter`.

## Requisitos del sistema
- **Sistema operativo:** Windows 10 u 11 (64 bits) con soporte para aplicaciones Flutter Desktop.
- **Flutter SDK:** versión 3.7.0 o superior (se recomienda mantener la versión estable más reciente).
- **Dart SDK:** incluido con Flutter.
- **Herramientas de compilación para Windows:**
  - Visual Studio 2022 con los componentes "Desktop development with C++" o el conjunto mínimo recomendado por Flutter.
  - Windows 10 SDK (10.0.19041.0 o superior).
- **Git** para clonar el repositorio.
- **PowerShell** o terminal compatible para ejecutar comandos.

> **Nota:** Aunque el proyecto se puede compilar en otras plataformas compatibles con Flutter (Linux, macOS, web), el enfoque y pruebas principales están orientados a Windows Desktop.

## Instalación
### 1. Preparar el entorno
1. Descarga e instala [Flutter](https://docs.flutter.dev/get-started/install/windows) siguiendo la guía oficial para Windows.
2. Añade el directorio `flutter\bin` a la variable de entorno `PATH`.
3. Verifica la instalación ejecutando en PowerShell:
   ```powershell
   flutter doctor
   ```
   Asegúrate de que no existan errores críticos antes de continuar.

### 2. Clonar el repositorio
```powershell
git clone https://github.com/<usuario>/MonitoringDostopApp-MDP-.git
cd MonitoringDostopApp-MDP-
```

### 3. Instalar dependencias
Flutter administra automáticamente las dependencias declaradas en `pubspec.yaml`.
```powershell
flutter pub get
```

### 4. Ejecutar la aplicación en modo desarrollo
#### Usando Visual Studio Code o Android Studio
- Abre la carpeta del proyecto.
- Selecciona el dispositivo `Windows (desktop)` en el selector de dispositivos.
- Presiona `F5` (VS Code) o el botón **Run** (Android Studio).

#### Usando terminal
```powershell
flutter run -d windows
```
Esto compilará e iniciará la aplicación en una ventana de escritorio nativa.

## Flujo de la aplicación
1. Al iniciar, se muestra la ventana principal con un `AppBar` y el contador.
2. En la sección central se visualiza el número de veces que se ha pulsado el botón.
3. Al presionar el botón flotante con el ícono `+`, la función `_incrementCounter` incrementa el valor interno y actualiza la UI.
4. El estado se mantiene mientras la aplicación esté abierta. Al reiniciar la app, el contador vuelve a cero.

Este flujo puede extenderse fácilmente para integrar fuentes de datos externas, paneles de monitoreo o gráficas, reutilizando el patrón `StatefulWidget` y/o migrando a patrones más avanzados como BLoC, Provider, Riverpod, etc.

## Ejecución de pruebas
Actualmente no se han definido pruebas personalizadas. No obstante, Flutter incluye un proyecto de ejemplo en el directorio `test/`. Para ejecutar los tests (y crear los tuyos propios en el futuro):
```powershell
flutter test
```

## Generar un paquete para Windows
Para crear un ejecutable listo para distribución:
```powershell
flutter build windows
```
El ejecutable se generará en `build\windows\runner\Release\`. Puedes comprimir esa carpeta y distribuirla a otros usuarios de Windows que cumplan los requisitos.

## Buenas prácticas para contribuciones
- Mantén el estilo de código siguiendo las guías de Flutter/Dart (`dart format`).
- Usa `flutter analyze` para identificar problemas estáticos.
- Asegúrate de que los tests existan y pasen antes de crear un _pull request_.
- Documenta cualquier cambio relevante en este README o en comentarios de código.

## Solución de problemas comunes
| Problema | Posible causa | Solución |
|----------|---------------|----------|
| `flutter doctor` muestra errores con Visual Studio | Falta de componentes C++ o SDK de Windows | Instala el "Desktop development with C++" y el SDK recomendado desde el instalador de Visual Studio. |
| Error `Failed to find tool. flutter.bat` | El PATH no incluye Flutter | Asegúrate de que `flutter\bin` esté en la variable PATH y reinicia la terminal. |
| La app se cierra inmediatamente al ejecutar | Dependencias incompletas o permisos | Ejecuta `flutter pub get`, limpia con `flutter clean` y vuelve a compilar. Revisa permisos de firewall si aplica. |
| Iconografía incorrecta o fuentes faltantes | Archivos no presentes en `assets/` o `fonts/` | Añade los recursos al proyecto y declara su ruta en `pubspec.yaml`. |

## Recursos adicionales
- [Documentación oficial de Flutter Desktop](https://docs.flutter.dev/desktop)
- [Guía de estilo de Dart](https://dart.dev/guides/language/effective-dart/style)
- [Canal de YouTube Flutter](https://www.youtube.com/c/flutterdev)

## Optimización de networking y caché
Las consultas de visitas ahora están protegidas con varias capas de robustez para evitar saturar el servidor y ofrecer respuestas rápidas:

- **Throttle y coalescing**: cada endpoint comparte un `Future` en vuelo y respeta un mínimo de 10 segundos entre actualizaciones automáticas, evitando ráfagas de peticiones.
- **Caché en memoria con TTL y stale-while-revalidate**: los datos se sirven inmediatamente desde caché (TTL configurable) mientras se revalidan en segundo plano cuando es necesario.
- **ETag/If-Modified-Since opcional**: se guardan los encabezados `ETag` y `Last-Modified` por URL y se envían en cada solicitud para aprovechar respuestas `304 Not Modified` cuando el servidor no ha cambiado.
- **Límite de concurrencia global**: el cliente sólo sostiene dos solicitudes simultáneas, previniendo la saturación del backend.
- **Botón "Actualizar"**: fuerza una actualización manual que omite throttle/TTL pero mantiene el coalescing y las validaciones condicionales.
- **`bustUrl` para imágenes**: las fotos se cargan con un parámetro de versión (`?v=`) basado en `updatedAt` (o un timestamp) y encabezados `no-cache`, garantizando que los cambios se reflejen al instante sin parpadeos (`gaplessPlayback`).

Los valores de intervalo de refresco automático, TTL y uso de ETag se pueden ajustar desde la pantalla de configuración.

---

¿Tienes dudas o quieres proponer una mejora? Abre un _issue_ o envía un _pull request_.

