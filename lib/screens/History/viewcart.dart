import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/screens/History/Transactioncard.dart';
import 'package:flutter/material.dart';

class Viewcart extends StatefulWidget {
  Viewcart({
    Key? key,
    required this.category,
    required this.type,
    required this.monthYear,
  }) : super(key: key);

  final String category;
  final String type;
  final String monthYear;

  @override
  _ViewcartState createState() => _ViewcartState();
}

class _ViewcartState extends State<Viewcart> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  late Query query;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  @override
  void initState() {
    super.initState();

    // query.limit(150).get().then((snapshot) {
    //   setState(() {
    //     data = snapshot.docs
    //         .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
    //         .toList();
    //   });
    // });
  }

  void removeTransaction(String documentId) {
    setState(() {
      data.removeWhere((element) => element.id == documentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    query = FirebaseFirestore.instance
        .collection('transaction')
        .where('uid', isEqualTo: user.toString())
        // .orderBy('created', descending: true)
        .where('monthYear', isEqualTo: widget.monthYear)
        .where('type', isEqualTo: widget.type);

    if (widget.category != "All") {
      query = query.where('category', isEqualTo: widget.category);
    }
    return FutureBuilder<QuerySnapshot>(
      future: query.limit(150).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Something went wrong"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No transaction found"),
          );
        }
        data = snapshot.data!.docs
            .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
            .toList();
        return ListView.builder(
          // shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            var cardData = data[index];
            return TransactionCard(
              data: cardData,
              documentId: cardData.id,
              onDelete: removeTransaction,
            );
          },
        );
      },
    );
  }
}
