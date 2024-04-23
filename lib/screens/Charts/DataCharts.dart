// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:card_swiper/card_swiper.dart';
import 'package:finance_tracker/authscreen/auth_page.dart';
import 'package:finance_tracker/screens/Charts/LineChart.dart';
import 'package:finance_tracker/screens/Charts/PieChart.dart';
import 'package:finance_tracker/screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final int? totalIncome;
  final int? totalExpense;
  const Chart({super.key, this.totalIncome, this.totalExpense});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void logOut(BuildContext context) {
    showDialog(
        // Remove the 'context' argument
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
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(12),
          // margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  icon: Icon(Icons.home_rounded, size: 30)),
              Icon(Icons.money, size: 30),
              Icon(
                Icons.home,
                size: 0,
              ),
              Icon(Icons.add_chart, size: 30),
              IconButton(
                onPressed: () {
                  logOut(context);
                },
                icon: Icon(Icons.person, size: 30),
                // Icon(Icons.account_circle, size: 40),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 370,
                  width: 350,
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
                          color: Colors.white,
                          activeColor: Colors.black,
                          activeSize: 10,
                          size: 8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
