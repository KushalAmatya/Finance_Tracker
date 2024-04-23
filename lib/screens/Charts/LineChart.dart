import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Linechart extends StatelessWidget {
  const Linechart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Linw Chart of Income and expense over time',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
            width: 300,
            height: 300,
            child: LineChart(LineChartData(
              minX: 0,
              maxX: 6,
              minY: 2000,
              maxY: 50000,
              gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white,
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.white,
                      strokeWidth: 0.5,
                    );
                  }),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white, width: 0.5),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 2000),
                    FlSpot(1, 50000),
                    FlSpot(2, 20000),
                    FlSpot(3, 5000),
                    FlSpot(4, 50000),
                    FlSpot(5, 2000),
                    FlSpot(6, 35000),
                  ],
                  isCurved: false,
                  color: Color.fromARGB(255, 162, 146, 95),
                  barWidth: 1.5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ))),
      ],
    ));
  }
}
