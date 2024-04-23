import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    // print(DateTime.parse(data['created']));
    DateTime dt = data['created'].toDate();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
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
                                spreadRadius: 4.0)
                          ]),
                      child: ListTile(
                        minVerticalPadding: 10,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        leading: Container(
                          width: 70,
                          height: 100,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green),
                            child: Center(
                              child: Icon(Icons.local_grocery_store),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(data['category'])),
                            Text(
                              data['amount'].toString(),
                              style: TextStyle(color: Colors.green),
                            )
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [],
                            ),
                            Text(DateFormat("MM/dd/yyyy hh:mm a").format(dt)),
                          ],
                        ),
                      ),
                    ));
              })
        ],
      ),
    );
  }
}
