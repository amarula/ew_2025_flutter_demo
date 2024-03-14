// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:ew_flutter_demo/widgets/weather_forecast_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showHeating = true;
  String _timeString = '';

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
        leading: TextButton(
          onPressed: () {
            setState(() {
              _showHeating = !_showHeating;
            });
          },
          child: const Icon(
            FontAwesomeIcons.bars,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(_timeString),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(FontAwesomeIcons.wifi),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          Visibility(
            visible: _showHeating,
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
          const Flexible(flex: 2, child: Placeholder())
        ],
      ),
    );
  }
}
