// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:ew_2025_flutter_demo/main.dart';
import 'package:ew_2025_flutter_demo/widgets/day_forecast_widget.dart';
import 'package:ew_2025_flutter_demo/widgets/temperature_text_widget.dart';

class WeatherForecastWidget extends StatefulWidget {
  const WeatherForecastWidget({
    super.key,
  });

  @override
  State<WeatherForecastWidget> createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  String degreeToCompass(double degree) {
    final array = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];

    final v = ((degree / 22.5) + .5).toInt();
    return array[(v % 16)];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: weatherForecastService,
      builder: (context, child) {
        if (weatherForecastService.forecast.isEmpty) {
          return const Center(
            child: Text(
              'No data\n\nReload Weather Forecast',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 48)),
                  SvgPicture.asset(
                    'assets/weather_icons/${weatherForecastService.currentWeather.weatherIcon}.svg',
                    width: 216,
                    height: 216,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        weatherForecastService.currentWeather.areaName!,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 16)),
                      Text(
                        weatherForecastService
                            .currentWeather.weatherDescription!.capitalize,
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TemperatureTextWidget(
                    degree: weatherForecastService
                        .currentWeather.temperature!.celsius!
                        .toStringAsFixed(0),
                    decimal: weatherForecastService
                        .currentWeather.temperature!.celsius!
                        .toStringAsFixed(1)
                        .split('.')[1]
                        .substring(0, 1),
                    fontSize: 120,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 48)),
                ],
              ),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 48)),
                  SvgPicture.asset(
                    'assets/weather_icons/wind.svg',
                    width: 48,
                    height: 48,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 8)),
                  Text(
                    '${degreeToCompass(weatherForecastService.currentWeather.windDegree!)} ${weatherForecastService.currentWeather.windSpeed} m/s',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/icons/humidity.png',
                    width: 40,
                    height: 40,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 8)),
                  Text(
                    '${weatherForecastService.currentWeather.humidity}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 48)),
                ],
              ),
              const Divider(
                thickness: 4,
              ),
              SizedBox(
                width: double.infinity,
                height: 192,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.all(8)),
                    DayForecastWidget(
                      weather: weatherForecastService.forecast[0],
                    ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    DayForecastWidget(
                      weather: weatherForecastService.forecast[1],
                    ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    DayForecastWidget(
                      weather: weatherForecastService.forecast[2],
                    ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    DayForecastWidget(
                      weather: weatherForecastService.forecast[3],
                    ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    DayForecastWidget(
                      weather: weatherForecastService.forecast[4],
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(4)),
            ],
          ),
        );
      },
    );
  }
}
