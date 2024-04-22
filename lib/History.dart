import 'package:finance_tracker/Category.dart';
import 'package:finance_tracker/Months.dart';
import 'package:finance_tracker/tabview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String currentCategory = "All";
  String currentMonth = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      currentMonth = DateFormat("MMM y").format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: Column(
        children: [
          Text("Transactions"),
          Months(onChanged: (String? value) {
            if (value != null) {
              setState(() {
                currentMonth = value;
              });
            }
            ;
          }),
          Category(onChanged: (String? value) {
            if (value != null) {
              setState(() {
                currentCategory = value;
              });
            }
          }),
          Tabview(category: currentCategory, currentmonth: currentMonth)
        ],
      ),
    );
  }
}
