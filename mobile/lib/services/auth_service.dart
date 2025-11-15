import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/profile_setup_page.dart';

class AuthService {
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("[AUTH][SUCCESS] Registration successful");

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ProfileSetupPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = '[AUTH][FAIL] The password you gave is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = '[AUTH][FAIL] That email is already in use';
      }
      debugPrint(message);
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("[AUTH][SUCCESS] Login successful");

      // // uncomment once HomePage is created
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Placeholder(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = '[AUTH][FAIL] No user found with that email';
      } else if (e.code == 'wrong-password') {
        message = '[AUTH][FAIL] Incorrect password for user with that email';
      }
      debugPrint(message);
    }
  }
}
