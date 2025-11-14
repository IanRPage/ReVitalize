import 'package:flutter/material.dart';
import 'package:mobile/pages/landing_page.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String _usernameField;
  late String _emailField;
  late String _passwordField;
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // gradient
          Container(
            height: 320,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF75F6B), Color(0xFFF2B177)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final h = c.maxHeight;
                final pad = w * 0.08;
                final maxContent = 560.0;
                final isSmall = h < 650;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxContent,
                      minHeight: h,
                    ),
                    child: Column(
                      children: [
                        // header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: pad),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // back button
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const LandingPage(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFFF75F6B),
                                ),
                                iconSize: 24,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              // header text
                              SizedBox(height: isSmall ? 4 : 20),
                              Text(
                                "Let's get you started!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Seems like you are new here. Let's set up your profile.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmall ? 14 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: isSmall ? pad / 2.5 : pad),
                            ],
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: pad,
                              vertical: isSmall ? pad / 4 : pad / 1.5,
                            ),
                            child: Column(
                              children: [
                                // TODO: username field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    Text(
                                      'Username',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    TextFormField(
                                      onChanged: (String value) {
                                        _usernameField = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: isSmall ? 8 : 16,
                                          horizontal: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 12 : 16),

                                // TODO: email field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    TextFormField(
                                      onChanged: (String value) {
                                        _emailField = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: isSmall ? 8 : 16,
                                          horizontal: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 12 : 16),

                                // TODO: password field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // eye button for password visibility
                                    TextFormField(
                                      onChanged: (String value) {
                                        _passwordField = value;
                                      },
                                      obscureText: isObscure,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isObscure
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isObscure = !isObscure;
                                            });
                                          },
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: isSmall ? 8 : 16,
                                          horizontal: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 20 : 24),

                                // TODO: sign up button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: TextButton(
                                    onPressed: () async {
                                      await AuthService().signup(
                                        email: _emailField,
                                        password: _passwordField,
                                        context: context,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5FD1E2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // divider
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Color(0xFFEDEDED),
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("or"),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xFFEDEDED),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: pad,
                            vertical: isSmall ? pad / 3 : pad / 1.5,
                          ),
                          child: Column(
                            children: [
                              // continue with google button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed:
                                      () {}, //TODO: Implement Google Login
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmall ? 12 : 15,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFFEDEDED),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          'assets/misc/google-logo.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Continue with Google",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: isSmall ? 8 : 16),

                              // continue with apple button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed:
                                      () {}, //TODO: Implement Apple Login
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmall ? 12 : 15,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFFEDEDED),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                          'assets/misc/apple-logo.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Continue with Apple",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // login button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account? ",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Color(0xFF5FD1E2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
