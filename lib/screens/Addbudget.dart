import 'package:finance_tracker/Models/Budgets.dart';
import 'package:finance_tracker/Services/database_services.dart';
import 'package:finance_tracker/screens/History/Category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AddBudgetPage extends StatefulWidget {
  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

bool thres = false;
bool exceed = false;

class _AddBudgetPageState extends State<AddBudgetPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final AmountController = TextEditingController();
  final CategoryController = TextEditingController();
  final NameController = TextEditingController();

  final DatabaseService _dbservice = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: NameController,
              decoration: InputDecoration(
                hintText: 'Budget Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: AmountController,
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            // Container(
            //   padding: EdgeInsets.only(left: 8),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     border: Border.all(color: Colors.black),
            //   ),
            //   child: DropdownButtonFormField<String>(
            //     decoration: InputDecoration(
            //       hintText: 'Periods',
            //       border: InputBorder.none,
            //     ),
            //     items: ['Monthly', 'Daily', 'Yearly', 'One-time']
            //         .map((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //     onChanged: (String? value) {},
            //   ),
            // ),
            // SizedBox(height: 10.0),
            TextField(
              controller: CategoryController,
              decoration: InputDecoration(
                hintText: 'Categories',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text('Budget Exceeded'),
                Spacer(),
                Switch(
                  value: exceed,
                  onChanged: (bool value) {
                    setState(() {
                      exceed = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text('75% More Exceeded'),
                Spacer(),
                Switch(
                  value: thres,
                  onChanged: (bool value) {
                    setState(() {
                      thres = value;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
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
                  onPressed: () {
                    if (NameController.text == "" ||
                        AmountController.text == "" ||
                        CategoryController == "") {
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
                      Budgets budgets = Budgets(
                          uid: user.uid,
                          category: CategoryController.text.toString(),
                          amount: int.parse(AmountController.text),
                          bname: NameController.text.toString(),
                          exceed: exceed,
                          thres: thres);
                      _dbservice.addbudget(budgets);
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
                  color: Color.fromRGBO(215, 178, 157, 1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddBudgetPage(),
  ));
}
