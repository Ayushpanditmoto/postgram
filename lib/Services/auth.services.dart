import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Utils/Toast.service.dart';

class AuthServies {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        ToastService.show(msg: 'User created successfully');
      });
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> signIn(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        ToastService.show(msg: 'User logged in successfully');
      });
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut().then((value) {
        ToastService.show(msg: 'User logged out successfully');
      });
    } catch (error) {
      rethrow;
    }
  }
}
