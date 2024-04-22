import 'package:finance_tracker/Transactioncard.dart';
import 'package:finance_tracker/viewcart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tabview extends StatelessWidget {
  const Tabview(
      {super.key, required this.category, required this.currentmonth});

  final String category;
  final String currentmonth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(tabs: [
                  Tab(text: "Expense"),
                  Tab(text: "Income"),
                ]),
                Expanded(
                  child: TabBarView(
                    children: [
                      Viewcart(
                          category: category,
                          type: "Expense",
                          monthYear: currentmonth),
                      Viewcart(
                          category: category,
                          type: "Income",
                          monthYear: currentmonth),
                    ],
                  ),
                )
              ],
            )));
  }
}
