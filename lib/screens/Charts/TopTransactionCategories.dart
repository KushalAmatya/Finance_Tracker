import 'package:finance_tracker/services/Transactionservices.dart';
import 'package:flutter/material.dart';

class TopTransactionCategories extends StatefulWidget {
  final String uid;

  const TopTransactionCategories({Key? key, required this.uid})
      : super(key: key);

  @override
  _TopTransactionCategoriesState createState() =>
      _TopTransactionCategoriesState();
}

class _TopTransactionCategoriesState extends State<TopTransactionCategories> {
  late Future<List<Map<String, dynamic>>> _topCategoriesFuture;

  final Map<String, Map<String, dynamic>> _item = {
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

  @override
  void initState() {
    super.initState();
    _topCategoriesFuture = TransactionService.getTopCategories(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _topCategoriesFuture,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> topCategories = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Top Transaction Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Column(
                    children: topCategories.map((category) {
                      String categoryName = category['category'];
                      int amount = category['amount'];
                      IconData icon = _item[categoryName]!['icon'];
                      Color color = _item[categoryName]!['color'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                  ),
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(categoryName),
                              ],
                            ),
                            Text(amount.toString()),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
