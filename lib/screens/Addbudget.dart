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
String? categoryitem;

class _AddBudgetPageState extends State<AddBudgetPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final AmountController = TextEditingController();
  final CategoryController = TextEditingController();
  final NameController = TextEditingController();
  final Map<String, Map<String, dynamic>> _item = {
    "Food": {"icon": Icons.fastfood, "color": Colors.red},
    "Entertainment": {"icon": Icons.movie, "color": Colors.blue},
    "Rent": {"icon": Icons.home, "color": Colors.orange},
    "Transportation": {"icon": Icons.directions_car, "color": Colors.green},
    "Education": {"icon": Icons.school, "color": Colors.purple},
    "Health": {"icon": Icons.local_hospital, "color": Colors.teal},
    "Others": {"icon": Icons.attach_money, "color": Colors.grey},
    // "Salary": {"icon": Icons.work, "color": Colors.green},
    // "Bonus": {"icon": Icons.monetization_on, "color": Colors.amber},
    // "Interest": {"icon": Icons.account_balance, "color": Colors.indigo},
  };

  @override
  void initState() {
    // TODO: implement initState
    categoryitem = null;
    thres = false;
    exceed = false;
    super.initState();
  }

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
                  borderSide: BorderSide(color: Colors.grey),
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
                  borderSide: BorderSide(color: Colors.grey),
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
            Container(
              width: 400,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.category_sharp,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Category:"),
                  SizedBox(
                    width: 80,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: categoryitem,
                      items: _item.entries
                          .map((MapEntry<String, Map<String, dynamic>> entry) {
                        final String category = entry.key;
                        final IconData icon = entry.value['icon'];
                        final Color color = entry.value['color'];
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                category,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
                ],
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
                  onPressed: () async {
                    if (NameController.text == "" ||
                        AmountController.text == "" ||
                        categoryitem == "" ||
                        categoryitem == null) {
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
                      final String category = categoryitem.toString();
                      final bool exists = await _dbservice.checkBudgetExists(
                          category, user.uid);
                      if (exists) {
                        toastification.show(
                            context: context,
                            title: Text('Budget Already Exists'),
                            autoCloseDuration: const Duration(seconds: 5),
                            description: RichText(
                                text: const TextSpan(
                                    text:
                                        'You already have a budget for this category')),
                            icon: Icon(Icons.cancel_presentation_sharp),
                            primaryColor: Colors.red);
                      } else {
                        Budgets budgets = Budgets(
                            uid: user.uid,
                            category: categoryitem.toString(),
                            amount: int.parse(AmountController.text),
                            bname: NameController.text.toString(),
                            exceed: exceed,
                            thres: thres);
                        _dbservice.addbudget(budgets);
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
