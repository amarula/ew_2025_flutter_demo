// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:ew_flutter_demo/services/boost_service.dart';
import 'package:ew_flutter_demo/widgets/heating_schedule_widget.dart';
import 'package:ew_flutter_demo/widgets/weather_forecast_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _timeString = '';
  final BoostService _boostService = BoostService();

  _updateTimeString() {
    final String formattedTime = DateFormat('kk:mm:ss').format(DateTime.now());

    setState(() {
      _timeString = formattedTime;
    });
  }

  @override
  void initState() {
    _updateTimeString();
    Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _updateTimeString());
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
                  _boostService.boostDurationSec = Random().nextInt(500);
                  _boostService.start();
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
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return WeatherForecastWidget(
                        height: constraints.maxHeight,
                      );
                    },
                  ),
                ),
                const Flexible(flex: 2, child: Placeholder())
              ],
            ),
          ),
          const Flexible(
            flex: 2,
            child: SizedBox.expand(
              child: HeatingScheduleWidget(),
            ),
          )
        ],
      ),
    );
  }
}
