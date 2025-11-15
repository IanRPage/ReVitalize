import 'package:firebase_auth/firebase_auth.dart';

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
  Future<AuthResult> signup({
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

  Future<AuthResult> login({
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
          password: 'Password is too weak (min 6 characters).',
        );
      case 'user-not-found':
        return const AuthFieldErrors(email: 'No user found with that email.');
      case 'wrong-password':
        return const AuthFieldErrors(password: 'Incorrect password.');
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
}
