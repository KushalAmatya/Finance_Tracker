import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  String uid;
  String category;
  int amount;
  String type;
  Timestamp created;

  Transactions(
      {required this.uid,
      required this.category,
      required this.amount,
      required this.type,
      required this.created});

  Transactions.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            amount: json['amount']! as int,
            category: json['category']! as String,
            type: json['type']! as String,
            created: json['created']! as Timestamp);

  Transactions copyWith({
    String? uid,
    String? category,
    int? amount,
    String? type,
    Timestamp? created,
  }) {
    return Transactions(
        uid: uid ?? this.uid,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        created: created ?? this.created);
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'category': category,
      'type': type,
      'amount': amount,
      'created': created
    };
  }
}
