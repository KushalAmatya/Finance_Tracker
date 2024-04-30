import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/screens/Charts/Indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Linechart extends StatefulWidget {
  const Linechart({super.key});
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  State<Linechart> createState() => _LinechartState();
}

class _LinechartState extends State<Linechart> {
  late List<Map<String, dynamic>> transactiondata = [];
  late List<Map<String, dynamic>> sortAmount = [];
  late List<Map<String, dynamic>> sortDate = [];
  late List<Map<String, dynamic>> incomeData = [];
  late List<Map<String, dynamic>> expenseData = [];
  bool isLoading = false;
  String yr = '';
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> temptransactiondata = [];
    // Fetch data from API
    QuerySnapshot data = await Linechart.firestore
        .collection('transaction')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (data.docs.isNotEmpty) {
      data.docs.forEach((element) {
        temptransactiondata.add(element.data() as Map<String, dynamic>);
      });

      setState(() {
        transactiondata = temptransactiondata;
        // yr = sortedDate;
        sortDate = transactiondata
          ..sort((a, b) => a['created'].compareTo(b['created']));
        sortAmount = transactiondata
          ..sort((a, b) => a['amount'].compareTo(b['amount']));
        incomeData = transactiondata
            .where((element) => element['type'] == 'Income')
            .toList();
        expenseData = transactiondata
            .where((element) => element['type'] == 'Expense')
            .toList();
        isLoading = false;
      });

      print(sortAmount);
      print(sortAmount[0]['amount']);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Transform.scale(
            child: CircularProgressIndicator(),
            scale: 0.1,
          )
        : Container(
            child: Column(
              children: [
                Text(
                  'Line Chart of Income and expense over time',
                  style: TextStyle(
                    fontSize: 16,
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
                    minX: sortDate.indexOf(sortDate[0]).toDouble(),
                    maxX: sortDate
                        .indexOf(sortDate[sortDate.length - 1])
                        .toDouble(),
                    minY: sortAmount[0]['amount'].toDouble(),
                    maxY:
                        sortAmount[sortAmount.length - 1]['amount'].toDouble(),
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
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: incomeData.map((data) {
                          print(sortDate.indexOf(sortDate[0]).toDouble());
                          print(data['amount'].toDouble());
                          double x = sortDate.indexOf(data).toDouble();
                          double y = data['amount'].toDouble();
                          return FlSpot(x, y);
                        }).toList(),
                        isCurved: true,
                        color: Color.fromARGB(255, 112, 206, 105),
                        barWidth: 1.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: expenseData.map((data) {
                          print(sortDate.indexOf(sortDate[0]).toDouble());
                          print(data['amount'].toDouble());
                          double x = sortDate.indexOf(data).toDouble();
                          double y = data['amount'].toDouble();
                          return FlSpot(x, y);
                        }).toList(),
                        isCurved: true,
                        color: Color.fromARGB(255, 252, 0, 0),
                        barWidth: 1.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  )),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Indicator(
                        color: Colors.green,
                        text: 'Income',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Expense',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          );
  }
}
