// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// Project imports:
import 'package:ew_2025_flutter_demo/main.dart';
import 'package:ew_2025_flutter_demo/services/home_setpoints_service.dart';
import 'package:ew_2025_flutter_demo/widgets/temperature_text_widget.dart';

class ThermostatStatus extends StatefulWidget {
  const ThermostatStatus({super.key});

  @override
  State<ThermostatStatus> createState() => _ThermostatStatusState();
}

class _ThermostatStatusState extends State<ThermostatStatus> {
  String weatherBasedOnPressure() {
    final pressure = sensorBoardService.pressure;

    if (pressure > 1020) {
      return 'assets/weather_icons/01d.svg';
    } else if (pressure > 1000) {
      return 'assets/weather_icons/03d.svg';
    }

    return 'assets/weather_icons/09d.svg';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sensorBoardService,
      builder: (context, child) {
        return Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 16)),
            Expanded(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 40)),
                  const Text(
                    'Humidity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      animationEnabled: false,
                      size: 352,
                      customWidths: CustomSliderWidths(
                        handlerSize: 16,
                        progressBarWidth: 16,
                        trackWidth: 16,
                      ),
                      customColors: CustomSliderColors(
                        trackColor: Colors.white70,
                        progressBarColors: <Color>[
                          Colors.blue,
                          Colors.blue.shade200,
                          Colors.blue.shade50,
                        ],
                      ),
                    ),
                    initialValue: HomeSetpointsService.humidity,
                    onChange: (double value) {
                      HomeSetpointsService.humidity = value;
                    },
                    innerWidget: (double value) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: value < sensorBoardService.humidity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/spinning_fan.json',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                                const Text(
                                  'Dehumidifying',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          Text(
                            '${sensorBoardService.humidity.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/humidity.png',
                                width: 32,
                                height: 32,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(
                                '${value.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const VerticalDivider(),
            SizedBox(
              width: 272,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 40)),
                  const Text(
                    'Pressure',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/icons/pressure.png',
                        width: 48,
                        height: 48,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      Text(
                        '${sensorBoardService.pressure.toStringAsFixed(1)} hPa',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    weatherBasedOnPressure(),
                    width: 128,
                    height: 128,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 40)),
                  const Text(
                    'Temperature',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      animationEnabled: false,
                      size: 352,
                      customWidths: CustomSliderWidths(
                        handlerSize: 16,
                        progressBarWidth: 16,
                        trackWidth: 16,
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
                    initialValue: HomeSetpointsService.temperature,
                    onChange: (double value) {
                      HomeSetpointsService.temperature = value;
                    },
                    innerWidget: (double value) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible:
                                value > (sensorBoardService.temperature + 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/fire.json',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Heating',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:
                                value < (sensorBoardService.temperature - 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/snow.json',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                                const Text(
                                  'Cooling',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          TemperatureTextWidget(
                            degree: sensorBoardService.temperature
                                .toStringAsFixed(0),
                            decimal: sensorBoardService.temperature
                                .toStringAsFixed(1)
                                .split('.')[1]
                                .substring(0, 1),
                            fontSize: 56,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/thermometer.png',
                                width: 32,
                                height: 32,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(
                                '${value.toInt()}°C',
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 16)),
          ],
        );
      },
    );
  }
}
