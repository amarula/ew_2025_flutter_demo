// Dart imports:
import 'dart:ffi' as ffi;
import 'dart:io' show Directory;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:path/path.dart' as path;

// Project imports:
import 'package:ew_2025_flutter_demo/pages/home_page.dart';
import 'package:ew_2025_flutter_demo/services/weather_forecast_service.dart';

final weatherForecastService = WeatherForecastService();

typedef HelloWorldFunc = ffi.Void Function();
typedef HelloWorld = void Function();

void main() {
  final libraryPath =
      path.join(Directory.current.path, 'thermostat_library', 'libhello.so');

  final dylib = ffi.DynamicLibrary.open(libraryPath);

  // ignore: omit_local_variable_types
  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<HelloWorldFunc>>('hello_world')
      .asFunction();

  hello();

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
