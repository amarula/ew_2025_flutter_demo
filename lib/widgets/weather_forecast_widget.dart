// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';

class WeatherForecastWidget extends StatefulWidget {
  const WeatherForecastWidget({
    required this.height,
    super.key,
  });

  final double height;

  @override
  State<WeatherForecastWidget> createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: widget.height,
          viewportFraction: 1,
        ),
        items: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Nuremberg',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.asset(
                'assets/lottie/weather_partly_cloud.json',
                height: 216,
              ),
              const Column(
                children: [
                  Text(
                    '15°',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    'Partly Cloud',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'MAX:19° MIN:5°',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Carpi',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.asset(
                'assets/lottie/weather_sunny.json',
                height: 216,
              ),
              const Column(
                children: [
                  Text(
                    '22°',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    'Sunny',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'MAX:23° MIN:15°',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'London',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.asset(
                'assets/lottie/weather_storm.json',
                height: 216,
              ),
              const Column(
                children: [
                  Text(
                    '10°',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    'Raining',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'MAX:11° MIN:4°',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
