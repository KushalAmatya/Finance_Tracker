import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Budgets {
  String uid;
  String bname;
  String category;
  int amount;
  bool exceed;
  bool thres;

  Budgets(
      {required this.uid,
      required this.bname,
      required this.category,
      required this.amount,
      required this.exceed,
      required this.thres});

  Budgets.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            bname: json['bname']! as String,
            amount: json['amount']! as int,
            category: json['category']! as String,
            exceed: json['exceed']! as bool,
            thres: json['thres']! as bool);

  Budgets copyWith(
      {String? uid,
      String? bname,
      String? category,
      int? amount,
      bool? exceed,
      bool? thres}) {
    return Budgets(
        uid: uid ?? this.uid,
        bname: bname ?? this.bname,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        exceed: exceed ?? this.exceed,
        thres: thres ?? this.thres);
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'bname': bname,
      'category': category,
      'amount': amount,
      'thres': thres,
      'exceed': exceed
    };
  }
}
