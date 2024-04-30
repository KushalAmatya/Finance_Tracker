import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {super.key,
      required this.data,
      required this.documentId,
      required this.onDelete});
  final dynamic data;
  final String documentId;
  final Function(String) onDelete;
  @override
  Widget build(BuildContext context) {
    DateTime dt = data['created'].toDate();
    IconData iconData = categoryData[data['category']]!['icon'];
    Color color = categoryData[data['category']]!['color'];
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Dismissible(
        background: Container(
          color: Colors.red,
          child: Icon(Icons.delete),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        key: ValueKey<String>(data['category']),
        onDismissed: (DismissDirection direction) {
          FirebaseFirestore.instance
              .collection('transaction')
              .doc(documentId)
              .delete()
              .then((_) => onDelete(documentId));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                color: Colors.grey.withOpacity(0.09),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            leading: Container(
              width: 70,
              height: 100,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.white,
                  ),
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
                SizedBox(height: 5),
                Text(DateFormat("MM/dd/yyyy hh:mm a").format(dt)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     // print(DateTime.parse(data['created']));
//     DateTime dt = data['created'].toDate();
//     IconData iconData = categoryData[data['category']]!['icon'];
//     Color color = categoryData[data['category']]!['color'];
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         children: [
//           ListView.builder(
//               shrinkWrap: true,
//               itemCount: 1,
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                                 offset: Offset(0, 10),
//                                 color: Colors.grey.withOpacity(0.09),
//                                 blurRadius: 10.0,
//                                 spreadRadius: 4.0)
//                           ]),
//                       child: ListTile(
//                         minVerticalPadding: 10,
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                         leading: Container(
//                           width: 70,
//                           height: 100,
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle, color: color),
//                             child: Center(
//                               child: Icon(
//                                 iconData,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Row(
//                           children: [
//                             Expanded(child: Text(data['category'])),
//                             Text(
//                               data['amount'].toString(),
//                               style: TextStyle(color: Colors.green),
//                             )
//                           ],
//                         ),
//                         subtitle: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [],
//                             ),
//                             Text(DateFormat("MM/dd/yyyy hh:mm a").format(dt)),
//                           ],
//                         ),
//                       ),
//                     ));
//               })
//         ],
//       ),
//     );
//   }
// }

const Map<String, Map<String, dynamic>> categoryData = {
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
