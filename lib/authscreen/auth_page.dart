import 'dart:html';

import 'package:finance_tracker/screens/Home.dart';
import 'package:finance_tracker/authscreen/login.dart';
import 'package:finance_tracker/authscreen/loginorregister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/authscreen/signup.dart';
import 'package:finance_tracker/screens/History/History.dart';

class Authpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          }
          //show loginpage if user press login and show signup page if user press signup
          return LoginOrRegister();
          // } else{
          //   return LoginOrRegister();
          // }
        },
      ),
    );
  }
}
