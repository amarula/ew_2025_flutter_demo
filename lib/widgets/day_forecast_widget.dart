// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:ew_2025_flutter_demo/services/weather_forecast_service.dart';

class DayForecastWidget extends StatefulWidget {
  const DayForecastWidget({
    required this.weather,
    super.key,
  });

  final DailyWeather weather;

  @override
  State<DayForecastWidget> createState() => _DayForecastWidgetState();
}

class _DayForecastWidgetState extends State<DayForecastWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            widget.weather.weekDay,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            'assets/weather_icons/${widget.weather.icon}.svg',
            width: 88,
            height: 88,
          ),
          const Spacer(),
          Text(
            '${widget.weather.tempMax} °C',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Text(
            '${widget.weather.tempMin} °C',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
