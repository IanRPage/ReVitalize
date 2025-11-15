import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/pages/signup_page.dart';
import 'package:mobile/pages/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/landing/gradient.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.2),
            ),
          ),

          // Foreground content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final pad = w * 0.08; // ~8% side padding
                final maxContent = 560.0; // keep a nice line length

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContent),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: pad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(flex: 4),

                          // logo
                          SvgPicture.asset(
                            'assets/landing/logo-2.svg',
                            width: w * 0.28,
                          ),

                          const SizedBox(height: 12),

                          // welcome
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Welcome to ReVitalize',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // subtext
                          SizedBox(
                            width: 270,
                            child: Text(
                              'Let us help you stay motivated and push yourself to do more.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const Spacer(flex: 6),

                          // get started button
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: const Color(0xFFFF6B6B),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // existing account button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFEDEDED),
                                  width: 2.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text(
                                'I already have an account',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
