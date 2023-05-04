import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //getter
  User? get user => _auth.currentUser;
}
