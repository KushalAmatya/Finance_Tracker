import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/Models/Transactions.dart';

const String Transaction_Collection = "transaction";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _transactionref;

  DatabaseService() {
    _transactionref = _firestore
        .collection(Transaction_Collection)
        .withConverter<Transactions>(
            fromFirestore: (snapshots, _) => Transactions.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (Transactions, _) => Transactions.toJson());
  }

  Stream<QuerySnapshot> getTransactions() {
    return _transactionref.snapshots();
  }

  void addtransaction(Transactions transactions) async {
    _transactionref.add(transactions);
  }
}
