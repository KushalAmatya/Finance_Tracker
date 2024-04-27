// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/screens/History/History.dart';
import 'package:finance_tracker/Models/Transactions.dart';
import 'package:finance_tracker/Services/database_services.dart';
import 'package:finance_tracker/screens/Charts/DataCharts.dart';
import 'package:finance_tracker/screens/Planning.dart';
import 'package:finance_tracker/screens/addTransaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;
  int totalIncome = 0;
  int totalExpense = 0;
  int flag = 0;
  bool sortby = true;
  final DatabaseService _dbservice = DatabaseService();
  initState() {
    super.initState();
    totalIncome = 0;
    totalExpense = 0;
    // Call a method to calculate totals when the widget initializes
    calculateTotals();
  }

  // Method to calculate totalIncome and totalExpense
  void calculateTotals() async {
    // Get the transactions
    QuerySnapshot transactions = await _dbservice.getTransactions().first;

    // Loop through the transactions
    for (var transaction in transactions.docs) {
      Transactions t = transaction.data() as Transactions;

      // Check if the transaction belongs to the current user
      if (t.uid == user.uid) {
        if (t.type == "Income") {
          totalIncome += t.amount;
        } else {
          totalExpense += t.amount;
        }
      }

      // Update the state to reflect changes
      setState(() {});
    }
  }

  // int calcIncome(){
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
                                      Navigator.pop(context);
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
    double screenWidth = MediaQuery.of(context).size.width;
    double leftPosition = screenWidth * 0.2;
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
                Icon(Icons.home_rounded, size: 30),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlanScreen()));
                    },
                    icon: Icon(Icons.money, size: 30)),
                Icon(
                  Icons.home,
                  size: 0,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chart(
                                    totalIncome: totalIncome,
                                    totalExpense: totalExpense,
                                  )));
                    },
                    icon: Icon(Icons.add_chart, size: 30)),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // print("hellp");

            final trans = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addItem()),
            ) as int?;

            setState(() {
              if (trans != null) {
                totalIncome = 0;
                totalExpense = 0;
                // flag = 1;
                // totalIncome += trans ?? 0;
                calculateTotals();
              }
            });
          },
          shape: CircleBorder(),
          backgroundColor: Color.fromRGBO(215, 178, 157, 1),
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: _dbservice.getTransactions(),
            builder: (context, snapshot) {
              List transactions = snapshot.data?.docs ?? [];

              if (transactions.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: _Header(context, totalIncome, totalExpense),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Transactions",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "view All",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Transactions",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }

              return SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                          height: 300,
                          child: _Header(context, totalIncome,
                              totalExpense) //Header(totalIncome: totalIncome),

                          ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            TextButton.icon(
                              icon: RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(Icons.more_sharp)),
                              label: Text('See More.'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => History()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      Transactions transaction = transactions[index].data();

                      if (transaction.uid != user.uid) {
                        return SizedBox.shrink(); // Skip this transaction
                      }
                      // return Text(transaction.category);
                      return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Icon(Icons.monetization_on),
                          ),
                          title: Text(
                            transaction.category,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            DateFormat("MM/dd/yyyy hh:mm a")
                                .format(transaction.created.toDate()),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: 12),
                          ),
                          trailing: Text(
                            transaction.type == "Income"
                                ? "+ " + transaction.amount.toString()
                                : "- " + transaction.amount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: transaction.type == "Income"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ));
                    }, childCount: transactions.length)),
                  ],
                ),
              );
            }));
  }
}

Widget _Header(BuildContext context, int totalIncome, int totalExpense) {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
                color: Color.fromRGBO(215, 178, 157, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Color.fromRGBO(250, 250, 250, 0.1),
                      child: Icon(
                        Icons.notification_add_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName ??
                            "User",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      Positioned(
        top: 130,
        left: 30,
        child: Center(
          child: Container(
            height: 170,
            width: 350,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 47, 125, 121),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(47, 125, 121, 0.3),
                      offset: Offset(5, 6),
                      blurRadius: 12,
                      spreadRadius: 6)
                ]),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "Total Balance",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Rs  ${(totalIncome - totalExpense).toString()}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color(0xff368983),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Income",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color(0xff368983),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Expenses",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        totalIncome.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        totalExpense.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}


// Widget head() {
//   return 
// }
