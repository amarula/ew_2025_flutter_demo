// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';

class HeatingScheduleWidget extends StatefulWidget {
  const HeatingScheduleWidget({
    super.key,
    Color? gradientColor1,
    Color? gradientColor2,
    Color? gradientColor3,
    Color? indicatorStrokeColor,
  })  : gradientColor1 = gradientColor1 ?? Colors.blue,
        gradientColor2 = gradientColor2 ?? Colors.orange,
        gradientColor3 = gradientColor3 ?? Colors.red,
        indicatorStrokeColor = indicatorStrokeColor ?? Colors.white;

  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color indicatorStrokeColor;

  @override
  State<HeatingScheduleWidget> createState() => _HeatingScheduleWidgetState();
}

class _HeatingScheduleWidgetState extends State<HeatingScheduleWidget> {
  List<int> showingTooltipOnSpots = [];

  List<FlSpot> get allSpots => const [
        FlSpot(0, 17),
        FlSpot(2, 17),
        FlSpot(4, 17),
        FlSpot(6, 17),
        FlSpot(8, 18),
        FlSpot(10, 20),
        FlSpot(12, 22),
        FlSpot(14, 22),
        FlSpot(16, 20),
        FlSpot(18, 18),
        FlSpot(20, 17),
        FlSpot(22, 17),
        FlSpot(23, 17),
      ];

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    const style = TextStyle(
      fontSize: 16,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '00';
      case 1:
        text = '01';
      case 2:
        text = '02';
      case 3:
        text = '03';
      case 4:
        text = '04';
      case 5:
        text = '05';
      case 6:
        text = '06';
      case 7:
        text = '07';
      case 8:
        text = '08';
      case 9:
        text = '09';
      case 10:
        text = '10';
      case 11:
        text = '11';
      case 12:
        text = '12';
      case 13:
        text = '13';
      case 14:
        text = '14';
      case 15:
        text = '15';
      case 16:
        text = '16';
      case 17:
        text = '17';
      case 18:
        text = '18';
      case 19:
        text = '19';
      case 20:
        text = '20';
      case 21:
        text = '21';
      case 22:
        text = '22';
      case 23:
        text = '23';
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: true,
        preventCurveOverShooting: true,
        barWidth: 4,
        shadow: const Shadow(
          blurRadius: 8,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              widget.gradientColor1.withOpacity(0.4),
              widget.gradientColor2.withOpacity(0.4),
              widget.gradientColor3.withOpacity(0.4),
            ],
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            widget.gradientColor1,
            widget.gradientColor2,
            widget.gradientColor3,
          ],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return LineChart(
              LineChartData(
                showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                  return ShowingTooltipIndicators([
                    LineBarSpot(
                      tooltipsOnBar,
                      lineBarsData.indexOf(tooltipsOnBar),
                      tooltipsOnBar.spots[index],
                    ),
                  ]);
                }).toList(),
                lineTouchData: LineTouchData(
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    if (response == null || response.lineBarSpots == null) {
                      return;
                    }
                    if (event is FlTapUpEvent) {
                      final spotIndex = response.lineBarSpots!.first.spotIndex;
                      setState(() {
                        if (showingTooltipOnSpots.contains(spotIndex)) {
                          showingTooltipOnSpots.remove(spotIndex);
                        } else {
                          showingTooltipOnSpots.add(spotIndex);
                        }
                      });
                    }
                  },
                  mouseCursorResolver:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    if (response == null || response.lineBarSpots == null) {
                      return SystemMouseCursors.basic;
                    }
                    return SystemMouseCursors.click;
                  },
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        const FlLine(
                          color: Colors.pink,
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 8,
                            color: lerpGradient(
                              barData.gradient!.colors,
                              barData.gradient!.stops!,
                              percent / 100,
                            ),
                            strokeWidth: 2,
                            strokeColor: widget.indicatorStrokeColor,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.pink,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        return LineTooltipItem(
                          lineBarSpot.y.toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: lineBarsData,
                minY: 16,
                maxY: 24,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return bottomTitleWidgets(
                          value,
                          meta,
                          constraints.maxWidth,
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.white54,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
