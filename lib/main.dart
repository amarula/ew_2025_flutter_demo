// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Project imports:
import 'package:ew_2025_flutter_demo/pages/home_page.dart';
import 'package:ew_2025_flutter_demo/services/sensor_board_service.dart';
import 'package:ew_2025_flutter_demo/services/weather_forecast_service.dart';

final weatherForecastService = WeatherForecastService();
final sensorBoardService = SensorBoardService();

void main() {
  sensorBoardService.init();

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
