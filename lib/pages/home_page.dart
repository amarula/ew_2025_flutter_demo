// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cron/cron.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'package:ew_2025_flutter_demo/main.dart';
import 'package:ew_2025_flutter_demo/widgets/thermostat_status.dart';
import 'package:ew_2025_flutter_demo/widgets/weather_forecast_widget.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageViewController = PageController();
  String _time =
      DateFormat.jm(Get.locale?.toLanguageTag()).format(DateTime.now());
  bool _showReloadForecast = false;

  @override
  void initState() {
    Cron().schedule(Schedule.parse('*/1 * * * *'), () async {
      setState(() {
        _time =
            DateFormat.jm(Get.locale?.toLanguageTag()).format(DateTime.now());
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(
          child: Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leadingWidth: 128,
        centerTitle: true,
        title: Text(
          _time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Visibility(
            visible: _showReloadForecast,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: () {
                  weatherForecastService
                    ..queryWeather()
                    ..queryForecast();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade900,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(56, 56),
                  maximumSize: const Size(56, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/icons/refresh.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                scrollBehavior: AppScrollBehavior(),
                controller: _pageViewController,
                onPageChanged: (value) {
                  setState(() {
                    _showReloadForecast = value == 1;
                  });
                },
                children: const [
                  ThermostatStatus(),
                  WeatherForecastWidget(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SmoothPageIndicator(
                controller: _pageViewController,
                count: 2,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
