import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/Models/Transactions.dart';

class TransactionService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> getTotalTransactionInfo(
      String uid) async {
    int totalTransactionCount = 0;
    int totalIncome = 0;
    int totalExpense = 0;

    QuerySnapshot data = await firestore
        .collection('transaction')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.docs.isNotEmpty) {
      totalTransactionCount = data.docs.length;
      totalIncome = data.docs
          .where((doc) => doc['type'] == 'Income')
          .fold(0, (sum, doc) => (sum + 1).toInt());
      totalExpense = data.docs
          .where((doc) => doc['type'] == 'Expense')
          .fold(0, (sum, doc) => (sum + 1).toInt());
    }

    return {
      'totalTransactionCount': totalTransactionCount,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
    };
  }

  static Future<List<Map<String, dynamic>>> getTopCategories(String uid) async {
    QuerySnapshot data = await firestore
        .collection('transaction')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.docs.isNotEmpty) {
      Map<String, int> categoryAmountMap = {};
      data.docs.forEach((transaction) {
        String category = transaction['category'];
        int amount = transaction['amount'];

        if (categoryAmountMap.containsKey(category)) {
          categoryAmountMap[category] = categoryAmountMap[category]! + amount;
        } else {
          categoryAmountMap[category] = amount;
        }
      });

      // Sort categories by amount
      List<MapEntry<String, int>> sortedCategories = categoryAmountMap.entries
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Take top three categories
      List<Map<String, dynamic>> topCategories = sortedCategories
          .sublist(0, sortedCategories.length > 3 ? 3 : sortedCategories.length)
          .map((entry) {
        return {'category': entry.key, 'amount': entry.value};
      }).toList();

      return topCategories;
    } else {
      return [];
    }
  }
}
