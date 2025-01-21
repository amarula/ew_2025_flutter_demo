// Dart imports:
import 'dart:ffi';
import 'dart:io' show Directory, File;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:path/path.dart' as path;

// Project imports:
import 'package:ew_2025_flutter_demo/pages/home_page.dart';
import 'package:ew_2025_flutter_demo/services/weather_forecast_service.dart';

final weatherForecastService = WeatherForecastService();

typedef VoidFuncCpp = Void Function();
typedef VoidFunc = void Function();

void main() {
  try {
    var libraryPath = path.join(
      Directory.current.path,
      'ew-2025-flutter-demo-can-lib',
      'build',
      'lib',
      'libfluttercan.so',
    );

    if (!File(libraryPath).existsSync()) {
      libraryPath = 'libfluttercan.so';
    }

    final lib = DynamicLibrary.open(libraryPath);

    final canStartRx = lib
        .lookup<NativeFunction<VoidFuncCpp>>('can_start_rx')
        .asFunction<VoidFunc>();

    canStartRx();
  } catch (e) {
    print('Failed to load dynamic library $e');
  }

  weatherForecastService
    ..init()
    ..queryWeather()
    ..queryForecast();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Thermostat',
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.shark,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
