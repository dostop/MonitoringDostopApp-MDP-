# Monitoring Dostop App (MDP)

Aplicación de escritorio desarrollada con Flutter para el monitoreo básico de eventos en un contador interactivo. Aunque la base del proyecto parte del _starter_ oficial de Flutter, este repositorio ha sido adaptado y configurado para ejecutarse principalmente en equipos con Windows.

## Tabla de contenidos
- [Visión general](#visión-general)
- [Características principales](#características-principales)
- [Arquitectura y estructura del proyecto](#arquitectura-y-estructura-del-proyecto)
- [Requisitos del sistema](#requisitos-del-sistema)
- [Instalación](#instalación)
  - [1. Preparar el entorno](#1-preparar-el-entorno)
  - [2. Clonar el repositorio](#2-clonar-el-repositorio)
  - [3. Instalar dependencias](#3-instalar-dependencias)
  - [4. Ejecutar la aplicación en modo desarrollo](#4-ejecutar-la-aplicación-en-modo-desarrollo)
- [Flujo de la aplicación](#flujo-de-la-aplicación)
- [Ejecución de pruebas](#ejecución-de-pruebas)
- [Generar un paquete para Windows](#generar-un-paquete-para-windows)
- [Buenas prácticas para contribuciones](#buenas-prácticas-para-contribuciones)
- [Solución de problemas comunes](#solución-de-problemas-comunes)
- [Recursos adicionales](#recursos-adicionales)

## Visión general
Monitoring Dostop App (MDP) es una aplicación Flutter orientada al monitoreo visual de un contador. El propósito principal es demostrar cómo construir, ejecutar y desplegar una aplicación de escritorio sencilla utilizando Flutter en Windows.

Si bien actualmente la funcionalidad se centra en un contador incremental, el proyecto sienta las bases para incorporar lógica de monitoreo más compleja (por ejemplo, integración con APIs, registro de eventos o visualización de métricas) aprovechando la arquitectura modular de Flutter.

## Características principales
- Interfaz ligera construida con widgets nativos de Flutter.
- Flujo de navegación simple con una única pantalla principal.
- Contador interactivo que permite al usuario incrementar valores con un botón flotante.
- Código listo para personalización rápida, ideal para experimentar con nuevas funcionalidades de monitoreo.
- Soporte para _hot reload_/_hot restart_ durante el desarrollo.

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

---

¿Tienes dudas o quieres proponer una mejora? Abre un _issue_ o envía un _pull request_.
