// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:finance_tracker/authscreen/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // void logOut(BuildContext context) {
  //   showDialog(
  //       // Remove the 'context' argument
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           child: Container(
  //             height: 400,
  //             width: 350,
  //             child: Column(
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(
  //                                 "You're Logged in as:",
  //                                 style: TextStyle(fontSize: 20),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(
  //                                 user.email!,
  //                                 style: TextStyle(fontSize: 20),
  //                               ),
  //                             ),
  //                           ])
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Column(
  //                         children: [
  //                           Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text(
  //                               "Log Out?",
  //                               style: TextStyle(fontSize: 20),
  //                             ),
  //                           ),
  //                           Row(
  //                             children: [
  //                               Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     signUserOut();
  //                                     Navigator.pop(context);
  //                                   },
  //                                   child: Text("Yes"),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     Navigator.pop(context);
  //                                   },
  //                                   child: Text("No"),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        // appBar: AppBar(
        //   leading: Icon(Icons.trending_up_rounded, size: 40),
        //   backgroundColor: Color.fromRGBO(215, 178, 157, 1),
        //   actions: [
        //     Text(user.email!),
        //     IconButton(
        //         onPressed: signUserOut, icon: Icon(Icons.logout, size: 40))
        //   ],
        // ),
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
                Icon(Icons.money, size: 30),
                Icon(
                  Icons.home,
                  size: 0,
                ),
                Icon(Icons.add_chart, size: 30),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person, size: 30),
                  // Icon(Icons.account_circle, size: 40),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: CircleBorder(),
          backgroundColor: Color.fromRGBO(215, 178, 157, 1),
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: 300, child: head()),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
              ),

              SliverList(delegate: SliverChildBuilderDelegate((context, index) {

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Icon(Icons.monetization_on),
                  ),
                  title: Text("Transportation",style:
                    TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600
                    ),),
                  subtitle: Text("4/12/2024",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 12
                  ),),
                  trailing: Text("- Rs. 25",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.red
                  ),),
                );
              }))
            ],
          ),
        ));
  }
}

Widget head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
                color: Color(0xff368983),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 300,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Kushal Amataya",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
        left: 20,
        child: Container(
          height: 170,
          width: 320,
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
                        fontSize: 16,
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
                      "Rs. 500.00",
                      style: TextStyle(
                        fontSize: 20,
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
                      "Rs. 300",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    Text(
                      "Rs. 300",
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
    ],
  );
}
