// Dart imports:
import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Directory, File;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:path/path.dart' as path;

typedef BoolFuncCpp = Bool Function();
typedef BoolFunc = bool Function();

typedef DoubleFuncCpp = Double Function();
typedef DoubleFunc = double Function();

class SensorBoardService with ChangeNotifier {
  late Timer _updateTimer;

  double _temperature = 0;
  double get temperature => _temperature;

  double _humidity = 0;
  double get humidity => _humidity;

  double _pressure = 0;
  double get pressure => _pressure;

  bool init() {
    try {
      var libraryPath = path.join(
        Directory.current.path,
        'ew-2025-flutter-demo-can-lib',
        'build',
        'lib',
        'libfluttercan.so.0',
      );

      if (!File(libraryPath).existsSync()) {
        libraryPath = 'libfluttercan.so.0';
      }

      final lib = DynamicLibrary.open(libraryPath);

      final canStartRx = lib
          .lookup<NativeFunction<BoolFuncCpp>>('can_start_rx')
          .asFunction<BoolFunc>();

      final getTemperature = lib
          .lookup<NativeFunction<DoubleFuncCpp>>('get_temperature')
          .asFunction<DoubleFunc>();

      final getHumidity = lib
          .lookup<NativeFunction<DoubleFuncCpp>>('get_humidity')
          .asFunction<DoubleFunc>();

      final getPressure = lib
          .lookup<NativeFunction<DoubleFuncCpp>>('get_pressure')
          .asFunction<DoubleFunc>();

      if (!canStartRx()) {
        return false;
      }

      _updateTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
        _temperature = getTemperature();
        _humidity = getHumidity();
        // kPa to hPa
        _pressure = getPressure() * 10;
        notifyListeners();
      });
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load dynamic library $e');
      return false;
    }

    return true;
  }

  void deinit() {
    _updateTimer.cancel();
  }
}
