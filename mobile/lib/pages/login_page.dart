import 'package:flutter/material.dart';
import 'package:mobile/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final AuthService? authService;

  const LoginPage({super.key, this.authService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // controller fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
  }

  bool _isObscure = true;
  bool _isSubmitting = false;
  AuthFieldErrors _fieldErrors = AuthFieldErrors.none;

  @override
  void dispose() {
    // cleanup so we don't leak memory
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _fieldErrors = AuthFieldErrors.none;
    });

    // validate form
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final result = await _authService.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!result.success) {
        setState(() => _fieldErrors = result.errors);

        _formKey.currentState!.validate();

        if (result.errors.general != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.errors.general!)));
        }

        return;
      }

      Navigator.of(context).pushReplacementNamed('/dashboard');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _fieldDecoration(bool isSmall) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(
        vertical: isSmall ? 8 : 16,
        horizontal: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
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
                final isSmall = h < 780;

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
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/landing_page');
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
                              SizedBox(height: isSmall ? 12 : 20),
                              Text(
                                "Welcome back!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Please enter your email and password to access your account.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: isSmall ? pad / 1.5 : pad),
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
                              vertical: isSmall ? pad / 2.5 : pad / 1.5,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: isSmall ? 8 : 16),

                                  // EMAIL FIELD
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        controller: _emailController,
                                        onChanged: (_) {
                                          if (_fieldErrors.email != null) {
                                            setState(() {
                                              _fieldErrors = _fieldErrors
                                                  .copyWith(email: null);
                                            });
                                          }
                                        },
                                        decoration: _fieldDecoration(isSmall),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          final v = value?.trim() ?? '';
                                          if (v.isEmpty) {
                                            return 'Email is required';
                                          }
                                          return _fieldErrors.email;
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // PASSWORD FIELD
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        controller: _passwordController,
                                        onChanged: (_) {
                                          if (_fieldErrors.password != null) {
                                            setState(() {
                                              _fieldErrors = _fieldErrors
                                                  .copyWith(password: null);
                                            });
                                          }
                                        },
                                        obscureText: _isObscure,
                                        decoration: _fieldDecoration(isSmall)
                                            .copyWith(
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isObscure
                                                      ? Icons.visibility_rounded
                                                      : Icons
                                                            .visibility_off_rounded,
                                                  color: Colors.grey[700],
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscure = !_isObscure;
                                                  });
                                                },
                                              ),
                                            ),
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) => _submit(),
                                        validator: (value) {
                                          final v = value ?? '';
                                          if (v.isEmpty) {
                                            return 'Password is required';
                                          }
                                          return _fieldErrors.password;
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // LOGIN BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: TextButton(
                                      onPressed: _isSubmitting ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF5FD1E2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: _isSubmitting
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'Login',
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
                            vertical: isSmall ? pad / 2.5 : pad / 1.5,
                          ),
                          child: Column(
                            children: [
                              // continue with google button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    setState(() => _isSubmitting = true);
                                    try {
                                      final result = await _authService
                                          .signUpWithGoogle();
                                      if (result.success) {
                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed('/dashboard');
                                      } else if (result.errors.general !=
                                          null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result.errors.general!,
                                            ),
                                          ),
                                        );
                                      }
                                    } finally {
                                      setState(() => _isSubmitting = false);
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
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

                              const SizedBox(height: 16),

                              // continue with apple button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed:
                                      () {}, // TODO: Implement Apple Login
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
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

      // sign up button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't an account? ",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/signup_page');
              },
              child: const Text(
                "Sign Up",
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
