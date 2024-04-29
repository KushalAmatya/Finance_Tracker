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
  final List<String> _incomeCategories = [
    "Salary",
    "Bonus",
    "Interest",
    "Others"
  ];
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
  final List<String> _expenseCategories = [
    "Food",
    "Entertainment",
    "Rent",
    "Transportation",
    "Education",
    "Health",
    "Others"
  ];
  List<String> _item = [];

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
    _item = _incomeCategories;
    super.initState();
  }

  Future<double> _getTotalAmountForCategory(String category) async {
    double totalAmount = 0;
    try {
      final transactionsSnapshot = await FirebaseFirestore.instance
          .collection('transaction')
          .where('uid', isEqualTo: user.uid)
          .where('category', isEqualTo: category)
          .get();

      for (var transaction in transactionsSnapshot.docs) {
        totalAmount += (transaction.data() as Map<String, dynamic>)['amount'];
      }

      print('Category: $category, Total Amount: $totalAmount');
    } catch (e) {
      print('Error calculating total amount for category: $e');
    }
    return totalAmount;
  }

  Future<void> _checkBudgetAndNotify(
      String category, double transactionAmount) async {
    try {
      // Get the budget for the category
      final budgetSnapshot = await FirebaseFirestore.instance
          .collection('budget')
          .where('uid', isEqualTo: user.uid)
          .where('category', isEqualTo: category)
          .limit(1)
          .get();

      // Check if a budget plan exists for the category
      if (budgetSnapshot.docs.isNotEmpty) {
        final budgetData = budgetSnapshot.docs.first.data();
        final double budgetAmount = budgetData['amount'];
        final bool isExceeded = budgetData['exceed'];
        final bool isThres = budgetData['thres'];

        // Calculate total amount for the category
        final totalAmountForCategory =
            await _getTotalAmountForCategory(category);
        print(totalAmountForCategory);
        print(budgetAmount);
        // Check if the transaction amount exceeds the budget amount
        if (totalAmountForCategory > 0.7 * budgetAmount &&
            isThres &&
            totalAmountForCategory < budgetAmount) {
          print("here inside");
          toastification.show(
            context: context,
            title: Text('Budget Exceeded'),
            autoCloseDuration: const Duration(seconds: 5),
            description: RichText(
              text: const TextSpan(
                text: "You have exceeded the budget's 70%  ",
              ),
            ),
            icon: Icon(Icons.warning),
            primaryColor: Colors.orange,
          );
        }

        // Check if the total amount for the category exceeds the budget amount
        if (totalAmountForCategory > budgetAmount && isExceeded) {
          toastification.show(
            context: context,
            title: Text('Budget Exceeded'),
            autoCloseDuration: const Duration(seconds: 5),
            description: RichText(
              text: const TextSpan(
                text: 'You have exceeded the budget',
              ),
            ),
            icon: Icon(Icons.warning),
            primaryColor: Colors.red,
          );
        }
      }
    } catch (e) {
      print('Error checking budget: $e');
    }
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                          // Change categories based on the selected transaction type
                          if (dropdownValue == 'Income') {
                            _item = _incomeCategories;
                          } else {
                            _item = _expenseCategories;
                          }
                          categoryitem = null; // Reset category selection
                        });
                      },
                      hint: Text('Transaction Type'),
                    ),
                  ],
                ),
              ),
              //
              SizedBox(
                height: 30,
              ),
              Container(
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: Colors.white),
                ),
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
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: categoryData[e]!['color']),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          categoryData[e]!['icon'],
                                          color: Colors.white,
                                        )),
                                  ),
                                  SizedBox(width: 10),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
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
                        await _dbservice.addtransaction(transactions);
                        final totalAmountForCategory =
                            await _getTotalAmountForCategory(
                                categoryitem.toString());

                        // Check budget
                        await _checkBudgetAndNotify(
                            categoryitem.toString(),
                            totalAmountForCategory +
                                int.parse(AmountController.text).toDouble());
                        Navigator.pop(
                            context, int.parse(AmountController.text));
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
                    color: Color.fromRGBO(215, 178, 157, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Save",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
