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
        message = 'The password you gave is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'That email is already in use';
      }
      print(message); // TODO: figure out logging
    } finally {
      print('Successful registration');
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

      // // uncomment once HomePage is created
      // await Future.delayed(const Duration(seconds: 1));
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => const HomePage(),
      //   ),
      // );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found with that email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password for user with that email';
      }
      print(message); // TODO: figure out logging
    } finally {
      print("Successful login");
    }
  }
}
