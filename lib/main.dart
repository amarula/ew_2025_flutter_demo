// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Project imports:
import 'package:ew_flutter_demo/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Thermostat',
      theme: FlexThemeData.light(scheme: FlexScheme.shark),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.shark),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
