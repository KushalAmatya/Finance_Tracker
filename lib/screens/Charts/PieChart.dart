import 'package:finance_tracker/screens/Charts/Indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Piechart extends StatefulWidget {
  final int? totalIncome;
  final int? totalExpense;
  const Piechart({super.key, this.totalIncome, this.totalExpense});

  @override
  State<Piechart> createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Colors.blue,
                text: 'Income',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.yellow,
                text: 'Expense',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    int total = widget.totalIncome! + widget.totalExpense!;
    double incomePercent = (widget.totalIncome! / total) * 100;
    double expensePercent = (widget.totalExpense! / total) * 100;
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.totalIncome?.toDouble(),
            title: incomePercent.toStringAsFixed(2) + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: widget.totalExpense?.toDouble(),
            title: expensePercent.toStringAsFixed(2) + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}





// Container(
//         child: Column(
//       children: [
//         Text(
//           'Pie Chart of Income vs Expense',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(
//           height: 30,
//         ),
//         Container(
//           width: 300,
//           height: 300,
//           child: PieChart(
//             PieChartData(sections: [
//               PieChartSectionData(
//                   color: Colors.blue,
//                   value: totalIncome?.toDouble(),
//                   title: 'Income',
//                   radius: 50),
//               PieChartSectionData(
//                   color: Colors.red,
//                   value: totalExpense?.toDouble(),
//                   title: 'Expense',
//                   radius: 50),
//             ], pieTouchData: PieTouchData()),
//             swapAnimationCurve: Curves.easeInOut,
//             swapAnimationDuration: const Duration(milliseconds: 150),
//           ),
//         ),
//       ],
//     ));