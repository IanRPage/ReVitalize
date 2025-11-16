import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/pages/signup_page.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/services/auth_service.dart';

class FakeAuthService extends AuthService {
  Future<AuthResult> Function({
    required String email,
    required String password,
  })?
  onSignup;

  Future<AuthResult> Function({
    required String email,
    required String password,
  })?
  onLogin;

  FakeAuthService({this.onSignup, this.onLogin});

  @override
  Future<AuthResult> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (onSignup != null) return onSignup!(email: email, password: password);
    return const AuthResult.success();
  }

  @override
  Future<AuthResult> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (onLogin != null) return onLogin!(email: email, password: password);
    return const AuthResult.success();
  }
}

void main() {
  testWidgets(
    'REGISTRATION_001: Assert invalid email format when registering for an account',
    (WidgetTester tester) async {
      final fake = FakeAuthService(
        onSignup: ({required email, required password}) async {
          return const AuthResult.failure(
            AuthFieldErrors(email: 'That email address is not valid.'),
          );
        },
      );
      await tester.pumpWidget(MaterialApp(home: SignUpPage(authService: fake)));
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'JohnDoe');
      await tester.enterText(fields.at(1), 'johndoe.com');
      await tester.enterText(fields.at(2), 'VitalGroup07_');

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('That email address is not valid.'), findsOneWidget);
    },
  );

  testWidgets('REGISTRATION_002: Assert weak password during registration', (
    WidgetTester tester,
  ) async {
    final fake = FakeAuthService(
      onSignup: ({required email, required password}) async {
        return const AuthResult.failure(
          AuthFieldErrors(password: 'Password must contain:'),
        );
      },
    );

    await tester.pumpWidget(MaterialApp(home: SignUpPage(authService: fake)));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'JohnDoe');
    await tester.enterText(fields.at(1), 'johndoe@gmail.com');
    await tester.enterText(fields.at(2), 'test123');

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.textContaining('Password must contain:'), findsOneWidget);
  });

  testWidgets('REGISTRATION_003: Fail registration with existing email', (
    WidgetTester tester,
  ) async {
    final fake = FakeAuthService(
      onSignup: ({required email, required password}) async {
        return const AuthResult.failure(
          AuthFieldErrors(email: 'An account already exists for that email.'),
        );
      },
    );

    await tester.pumpWidget(MaterialApp(home: SignUpPage(authService: fake)));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Vital');
    await tester.enterText(fields.at(1), 'revitalize@gmail.com');
    await tester.enterText(fields.at(2), 'VitalGroup07_');

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(
      find.text('An account already exists for that email.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'REGISTRATION_004: Verify redirection after successful account registration',
    (WidgetTester tester) async {
      final fake = FakeAuthService(
        onSignup: ({required email, required password}) async {
          return const AuthResult.success();
        },
      );

      await tester.pumpWidget(MaterialApp(home: SignUpPage(authService: fake)));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'JohnDoe');
      await tester.enterText(fields.at(1), 'johndoe@gmail.com');
      await tester.enterText(fields.at(2), 'VitalGroup07_');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Setup'), findsOneWidget);
    },
  );

  testWidgets('LOGIN_001: Prevent login with unregistered email', (
    WidgetTester tester,
  ) async {
    final fake = FakeAuthService(
      onLogin: ({required email, required password}) async {
        return const AuthResult.failure(
          AuthFieldErrors(
            password: 'The username or password entered is incorrect',
          ),
        );
      },
    );

    await tester.pumpWidget(MaterialApp(home: LoginPage(authService: fake)));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'johndoe@gmail.com');
    await tester.enterText(fields.at(1), 'VitalGroup07_');

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(
      find.text('The username or password entered is incorrect'),
      findsOneWidget,
    );
  });

  testWidgets(
    'LOGIN_002: Prevent login with correct user but incorrect password',
    (WidgetTester tester) async {
      final fake = FakeAuthService(
        onLogin: ({required email, required password}) async {
          return const AuthResult.failure(
            AuthFieldErrors(
              password: 'The username or password entered is incorrect',
            ),
          );
        },
      );

      await tester.pumpWidget(MaterialApp(home: LoginPage(authService: fake)));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'revitalize@gmail.com');
      await tester.enterText(fields.at(1), 'test123');

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(
        find.text('The username or password entered is incorrect'),
        findsOneWidget,
      );
    },
  );
}
