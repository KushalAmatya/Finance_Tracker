import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/Models/Transactions.dart';
import 'package:finance_tracker/screens/Addbudget.dart';
import 'package:finance_tracker/screens/History/Category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:finance_tracker/Services/database_services.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseService _dbservice = DatabaseService();
  final user = FirebaseAuth.instance.currentUser!;
  late List<Map<String, dynamic>> budgetData = [];

  final Map<String, Map<String, dynamic>> categoryData = {
    "Food": {"icon": Icons.fastfood, "color": Colors.red},
    "Entertainment": {"icon": Icons.movie, "color": Colors.blue},
    "Rent": {"icon": Icons.home, "color": Colors.orange},
    "Transportation": {"icon": Icons.directions_car, "color": Colors.green},
    "Education": {"icon": Icons.school, "color": Colors.purple},
    "Health": {"icon": Icons.local_hospital, "color": Colors.teal},
    "Others": {"icon": Icons.attach_money, "color": Colors.grey},
    "Salary": {"icon": Icons.work, "color": Colors.green},
    "Bonus": {"icon": Icons.monetization_on, "color": Colors.amber},
    "Interest": {"icon": Icons.account_balance, "color": Colors.indigo},
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('budget')
        .where('uid', isEqualTo: user.uid)
        .limit(150)
        .get();

    setState(() {
      budgetData = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  Future<List<double>> calculateTotalAmounts() async {
    List<double> totalAmounts = [];

    for (var cardData in budgetData) {
      String category = cardData['category'];
      double totalAmount = 0;

      QuerySnapshot transactions = await _dbservice.getTransactions().first;

      for (var transaction in transactions.docs) {
        Transactions t = transaction.data() as Transactions;

        if (t.uid == user.uid && t.category == category) {
          totalAmount += t.amount;
        }
      }

      totalAmounts.add(totalAmount);
    }

    return totalAmounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: FutureBuilder<List<double>>(
          future: calculateTotalAmounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong"));
            }
            List<double> totalAmounts = snapshot.data ?? [];
            if (snapshot.data!.isEmpty) {
              return Center(child: Text("No budget found"));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: budgetData.length,
                    itemBuilder: (context, index) {
                      var cardData = budgetData[index];
                      String category = cardData['category'];
                      // String bname = cardData['bname'];
                      double amount = cardData['amount'].toDouble();
                      double totalAmount =
                          totalAmounts.isNotEmpty ? totalAmounts[index] : 0;
                      double percent =
                          totalAmount != 0 ? totalAmount / amount : 0;
                      print(totalAmount);
                      String documentId = cardData['id'];
                      IconData iconData = categoryData[category]!['icon'];
                      Color color = categoryData[category]!['color'];
                      return Dismissible(
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        key: ValueKey<String>(cardData['category']),
                        onDismissed: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            _dbservice.deletebudget(documentId);
                            _fetchData();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 10),
                                  color: Colors.grey.withOpacity(0.09),
                                  blurRadius: 10.0,
                                  spreadRadius: 4.0,
                                ),
                              ],
                            ),
                            child: ListTile(
                              minVerticalPadding: 10,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                              leading: Container(
                                width: 70,
                                height: 100,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      iconData,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      category.toUpperCase(),
                                    ),
                                  ),
                                  PopupMenuButton(
                                    color: Colors.white,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: "edit",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 8),
                                            Text("Edit"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "delete",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 8),
                                            Text("Delete"),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == "edit") {
                                        // Handle edit action
                                      } else if (value == "delete") {
                                        _dbservice.deletebudget(documentId);
                                        _fetchData();
                                        // Handle delete action
                                      }
                                    },
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      LinearPercentIndicator(
                                        width: 100,
                                        barRadius: Radius.circular(5),
                                        lineHeight: 10,
                                        animation: true,
                                        animationDuration: 1000,
                                        percent: percent > 1.0 ? 1.0 : percent,
                                        progressColor: color,
                                      ),
                                      Text((percent * 100).toStringAsFixed(2) +
                                          "%"),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(amount.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color.fromRGBO(215, 178, 157, 1),
        onPressed: () async {
          final addedAmount = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBudgetPage()),
          );

          if (addedAmount != null) {
            // Refresh budget data when AddBudgetPage is popped
            await _fetchData();
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
