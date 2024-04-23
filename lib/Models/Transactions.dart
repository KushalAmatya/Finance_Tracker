import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  String uid;
  String category;
  int amount;
  String type;
  Timestamp created;
  String monthYear;

  Transactions(
      {required this.uid,
      required this.category,
      required this.amount,
      required this.type,
      required this.created,
      required this.monthYear});

  Transactions.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            amount: json['amount']! as int,
            category: json['category']! as String,
            type: json['type']! as String,
            created: json['created']! as Timestamp,
            monthYear: json['monthYear']! as String);

  Transactions copyWith({
    String? uid,
    String? category,
    int? amount,
    String? type,
    Timestamp? created,
    String? monthYear,
  }) {
    return Transactions(
        uid: uid ?? this.uid,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        created: created ?? this.created,
        monthYear: monthYear ?? this.monthYear);
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'category': category,
      'type': type,
      'amount': amount,
      'created': created,
      'monthYear': monthYear
    };
  }
}
