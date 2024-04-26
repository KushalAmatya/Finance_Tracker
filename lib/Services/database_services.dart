import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/Models/Budgets.dart';
import 'package:finance_tracker/Models/Transactions.dart';

const String Transaction_Collection = "transaction";
const String Budget_Collection = "Budget";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _transactionref;
  late final CollectionReference _budgetref;

  DatabaseService() {
    _transactionref = _firestore
        .collection(Transaction_Collection)
        .withConverter<Transactions>(
            fromFirestore: (snapshots, _) => Transactions.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (Transactions, _) => Transactions.toJson());

    _budgetref =
        _firestore.collection(Budget_Collection).withConverter<Budgets>(
            fromFirestore: (snapshots, _) => Budgets.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (Budgets, _) => Budgets.toJson());
  }

  Stream<QuerySnapshot> getTransactions() {
    return _transactionref.snapshots();
  }

  Stream<QuerySnapshot> getBudget() {
    return _budgetref.snapshots();
  }

  void addtransaction(Transactions transactions) async {
    _transactionref.add(transactions);
  }

  void addbudget(Budgets budgets) async {
    _budgetref.add(budgets);
  }
}
