// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/Services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:finance_tracker/Models/Transactions.dart';
import 'package:toastification/toastification.dart';

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
  final List<String> _item = [
    "Food",
    "Entertainment",
    "Rent",
    "Transportation",
    "Education",
    "Health",
    "Others"
  ];
  final user = FirebaseAuth.instance.currentUser!;
  final AmountController = TextEditingController();
  final DateController = TextEditingController();
  String dropdownValue = dropdownMenuEntries[0];

  final DatabaseService _dbservice = DatabaseService();

  String? categoryitem;
  DateTime selectedDate = DateTime.now();
  String? monthYear;

  @override
  void initState() {
    // TODO: implement initState
    DateController.text = DateFormat("MM/dd/yyy").format(DateTime.now());
    monthYear = DateFormat("MMM y").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Add Transaction'),
      ),
      body: Center(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),

              Container(
                width: 400,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: AmountController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.currency_rupee,
                        size: 20,
                        color: Colors.grey,
                      ),
                      hintText: "Amount",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              //
              Container(
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 2, color: Colors.white)),
                child: DropdownButton<String>(
                  value: categoryitem,
                  items: _item
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                  ),
                                  Text(
                                    e,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                  hint: Text(
                    "Category",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  underline: Container(),
                  onChanged: ((value) {
                    setState(() {
                      categoryitem = value!;
                    });
                  }),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Row(
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
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: DateController,
                textAlignVertical: TextAlignVertical.center,
                readOnly: true,
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2022),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (newDate != null) {
                    setState(() {
                      DateController.text =
                          DateFormat("MM/dd/yyy").format(newDate);
                      selectedDate = newDate;
                      monthYear = DateFormat("MMM y").format(newDate);
                    });
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.access_time_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    hintText: "Date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                    backgroundColor: Color.fromARGB(255, 47, 125, 121),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  // Add transaction

                  var time = DateTime.parse(selectedDate.toString());
                  var totime = Timestamp.fromDate(time);
                  if (categoryitem == null || AmountController.text == "") {
                    toastification.show(
                        context: context,
                        title: Text('Empty Fields'),
                        autoCloseDuration: const Duration(seconds: 5),
                        description: RichText(
                            text: const TextSpan(
                                text: 'Please fill all the fields ')),
                        icon: Icon(Icons.cancel_presentation_sharp),
                        primaryColor: Colors.red);
                  } else {
                    Transactions transactions = Transactions(
                        uid: user.uid,
                        category: categoryitem.toString(),
                        amount: int.parse(AmountController.text),
                        type: dropdownValue,
                        monthYear: monthYear.toString(),
                        // created: DateTime.parse(DateController.text));
                        created: totime);
                    _dbservice.addtransaction(transactions);
                    Navigator.pop(context, int.parse(AmountController.text));
                    toastification.show(
                        context: context,
                        title: Text('Successfully added'),
                        autoCloseDuration: const Duration(seconds: 3),
                        description: RichText(
                            text: const TextSpan(
                                text: 'Please check the statement')),
                        icon: Icon(Icons.check_circle_outlined),
                        primaryColor: Colors.green);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
