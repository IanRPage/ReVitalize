import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class AuthFieldErrors {
  final String? email;
  final String? password;
  final String? general;

  const AuthFieldErrors({this.email, this.password, this.general});

  bool get hasErrors => email != null || password != null || general != null;

  AuthFieldErrors copyWith({String? email, String? password, String? general}) {
    return AuthFieldErrors(
      email: email ?? this.email,
      password: password ?? this.password,
      general: general ?? this.general,
    );
  }

  static const none = AuthFieldErrors();
}

class AuthResult {
  final bool success;
  final AuthFieldErrors errors;

  // const AuthResult._(this.success, this.errors);

  const AuthResult.success() : success = true, errors = AuthFieldErrors.none;

  const AuthResult.failure(AuthFieldErrors errors)
    : success = false,
      errors = errors;
}

class AuthService {
  Future<AuthResult> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseErrorToFieldErrors(e));
    } catch (_) {
      return const AuthResult.failure(
        AuthFieldErrors(general: 'Unexpected error. Please try again'),
      );
    }
  }

  Future<AuthResult> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_mapFirebaseErrorToFieldErrors(e));
    } catch (e) {
      return const AuthResult.failure(
        AuthFieldErrors(general: 'Unexpected error. Please try again'),
      );
    }
  }

  // TODO: add more FirebaseAuthException code cases
  AuthFieldErrors _mapFirebaseErrorToFieldErrors(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const AuthFieldErrors(
          email: 'An account already exists for that email.',
        );
      case 'invalid-email':
        return const AuthFieldErrors(email: 'That email address is not valid.');
      case 'weak-password':
        return const AuthFieldErrors(
          password: 'Password is too weak, make it stronger.',
        );
      case 'invalid-credential':
        return const AuthFieldErrors(
          password: 'The username or password entered is incorrect',
        );
      default:
        return const AuthFieldErrors(
          general: 'Authentication failed. Please try again.',
        );
    }
  }

  Future<AuthResult> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: const ['email'],
      ).signIn();

      if (googleUser == null) {
        return const AuthResult.failure(
          AuthFieldErrors(general: 'Google sign-in was cancelled'),
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return const AuthResult.success();
    } on FirebaseAuthException catch (e) {
      print(
        'FirebaseAuthException during Google sign-in: ${e.code} ${e.message}',
      );
      return AuthResult.failure(_mapFirebaseErrorToFieldErrors(e));
    } on PlatformException catch (e) {
      print('PlatformException during Google sign-in: ${e.code} ${e.message}');
      return AuthResult.failure(
        AuthFieldErrors(
          general: e.message ?? 'Platform error during Google sign-in.',
        ),
      );
    } catch (e, st) {
      print('Unknown error during Google sign-in: $e');
      print(st);
      return AuthResult.failure(AuthFieldErrors(general: e.toString()));
    }
  }
}
