// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:js_util';

import 'package:card_swiper/card_swiper.dart';
import 'package:finance_tracker/authscreen/auth_page.dart';
import 'package:finance_tracker/screens/Charts/LineChart.dart';
import 'package:finance_tracker/screens/Charts/PieChart.dart';
import 'package:finance_tracker/screens/Charts/TopTransactionCategories.dart';
// import 'package:finance_tracker/screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Services/Transactionservices.dart';

class Chart extends StatefulWidget {
  final int? totalIncome;
  final int? totalExpense;
  const Chart({super.key, this.totalIncome, this.totalExpense});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<Map<String, dynamic>> _transactionInfoFuture;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactionInfoFuture =
        TransactionService.getTotalTransactionInfo(user.uid);
  }

  void logOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 400,
              width: 350,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "You're Logged in as:",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  user.email!,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ])
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Log Out?",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      signUserOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Authpage()));
                                    },
                                    child: Text("Yes"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charts"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      // bottomNavigationBar: SafeArea(
      //   child: Container(
      //     // padding: EdgeInsets.all(12),
      //     // margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         IconButton(
      //             onPressed: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(builder: (context) => Home()),
      //               );
      //             },
      //             icon: Icon(Icons.home_rounded, size: 30)),
      //         Icon(Icons.money, size: 30),
      //         Icon(
      //           Icons.home,
      //           size: 0,
      //         ),
      //         Icon(Icons.add_chart, size: 30),
      //         IconButton(
      //           onPressed: () {
      //             logOut(context);
      //           },
      //           icon: Icon(Icons.person, size: 30),
      //           // Icon(Icons.account_circle, size: 40),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 40,
              // ),
              // SizedBox(
              //   height: 10,
              // ),

              Center(
                child: Container(
                  height: 450,
                  width: 400,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Piechart(
                            totalIncome: widget.totalIncome,
                            totalExpense: widget.totalExpense);
                      } else if (index == 1) {
                        return Linechart();
                      } else {
                        return Container();
                      }
                    },
                    itemCount: 2,
                    pagination: SwiperPagination(
                      margin: EdgeInsets.only(top: 15),
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.grey,
                          activeColor: Colors.black,
                          activeSize: 10,
                          size: 8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: _transactionInfoFuture,
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int totalTransactionCount =
                          snapshot.data!['totalTransactionCount'];
                      int totalIncome = snapshot.data!['totalIncome'];
                      int totalExpense = snapshot.data!['totalExpense'];
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfoBox(
                                  label: 'Total Transactions',
                                  value: totalTransactionCount.toString(),
                                  color: Colors.blue,
                                ),
                                _buildInfoBox(
                                  label: 'Total Income',
                                  value: totalIncome.toString(),
                                  color: Colors.green,
                                ),
                                _buildInfoBox(
                                  label: 'Total Expense',
                                  value: totalExpense.toString(),
                                  color: Colors.red,
                                ),
                              ],
                            )
                          ]);
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              TopTransactionCategories(uid: user.uid)
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoBox(
    {required String label, required String value, required Color color}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
