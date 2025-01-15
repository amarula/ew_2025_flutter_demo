// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// Project imports:
import 'package:ew_2025_flutter_demo/services/boost_service.dart';
import 'package:ew_2025_flutter_demo/widgets/heating_schedule_widget.dart';
import 'package:ew_2025_flutter_demo/widgets/weather_forecast_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BoostService _boostService = BoostService(
    onBoostFinished: () {
      _setSetpoint(21);
    },
  );
  String _timeString = '';
  int _thermostatSetpoint = 21;

  void _updateTimeString() {
    final formattedTime = DateFormat('kk:mm:ss').format(DateTime.now());

    _timeString = formattedTime;
    setState(() {});
  }

  void _setSetpoint(int setpoint) {
    _thermostatSetpoint = setpoint;
    setState(() {});
  }

  @override
  void initState() {
    _updateTimeString();
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTimeString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                if (_boostService.boosting) {
                  _boostService.stop();
                } else {
                  _boostService
                    ..boostDurationSec = 10
                    ..start();
                  _setSetpoint(40);
                }
              },
              child: Icon(
                _boostService.boosting
                    ? FontAwesomeIcons.pause
                    : FontAwesomeIcons.play,
                color: Colors.white,
              ),
            ),
            Visibility(
              visible: _boostService.boosting,
              child: Text(
                _boostService.boostRemaining(),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          _timeString,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(FontAwesomeIcons.wifi),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          Visibility(
            visible: _thermostatSetpoint != 21,
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(FontAwesomeIcons.handPointUp),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          Visibility(
            visible: _boostService.boosting,
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(FontAwesomeIcons.fire),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return WeatherForecastWidget(
                        height: constraints.maxHeight,
                      );
                    },
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white54,
                ),
                Flexible(
                  flex: 2,
                  child: Center(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(24)),
                        SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            animDurationMultiplier: 0,
                            size: 368,
                            customWidths: CustomSliderWidths(
                              handlerSize: 16,
                              progressBarWidth: 16,
                              trackWidth: 1,
                            ),
                            customColors: CustomSliderColors(
                              trackColor: Colors.white70,
                              progressBarColors: <Color>[
                                Colors.red,
                                Colors.orange,
                                Colors.blue,
                              ],
                            ),
                          ),
                          min: 5,
                          max: 40,
                          initialValue: _thermostatSetpoint.toDouble(),
                          onChange: (double value) {
                            _setSetpoint(value.toInt());
                          },
                          innerWidget: (double value) {
                            return Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '${value.toInt()}°C',
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.temperatureHalf,
                                        size: 32,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                      Text(
                                        '21°C',
                                        style: TextStyle(
                                          fontSize: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          const Flexible(
            flex: 2,
            child: SizedBox.expand(
              child: HeatingScheduleWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
