import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/Transactioncard.dart';

class Viewcart extends StatelessWidget {
  Viewcart(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});
  final user = FirebaseAuth.instance.currentUser!.uid;

  final String category;
  final String type;
  final String monthYear;
  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('transaction')
        .where('uid', isEqualTo: user.toString())
        // .orderBy('created', descending: true)
        // // .where('monthYear', isEqualTo: monthYear)
        .where('type', isEqualTo: type);

    if (category != "All") {
      query = query.where('category', isEqualTo: category);
    }

    return FutureBuilder<QuerySnapshot>(
        future: query.limit(150).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // print(snapshot.data);
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Something went wrong"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("loading"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Center(child: Text("No transaction found")),
            );
          }

          var data = snapshot.data!.docs;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var cardData = data[index];
                return TransactionCard(data: cardData);
              });
        });
  }
}
