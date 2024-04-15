// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addItem extends StatefulWidget {
  const addItem({super.key});

  @override
  State<addItem> createState() => _addItemState();
}

class _addItemState extends State<addItem> {
  static final List<String> dropdownMenuEntries = <String>[
    'Income',
    'Expense',
  ];
  final TransactionController = TextEditingController();
  final AmountController = TextEditingController();
  String dropdownValue = dropdownMenuEntries[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              width: 400,
              child: TextField(
                controller: TransactionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Transaction Name',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 400,
              child: TextField(
                controller: AmountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Type:"),
                SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  items: dropdownMenuEntries
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newVal) {
                    setState(() {
                      dropdownValue = newVal!;
                    });
                  },
                  hint: Text('Transaction Type'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2100),
                onDateChanged: (DateTime date) {
                  print(date);
                }),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // Add transaction
              },
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
