import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/pages/communities.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/leaderboard.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/pages/notifications.dart';
import 'package:mobile/pages/profile_setup_page.dart';
import 'package:mobile/pages/signup_page.dart';
import 'firebase_options.dart';
import 'pages/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReVitalize',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/landing_page',
      routes: {
        '/landing_page': (context) => const LandingPage(),
        '/signup_page': (context) => const SignUpPage(),
        '/login_page': (context) => const LoginPage(),
        '/profile_setup': (context) => const ProfileSetupPage(),
        '/dashboard': (context) => const Dashboard(),
        '/leaderboard': (context) => const Leaderboard(),
        '/communities': (context) => const Communities(),
        '/notifications': (context) => const Notifications(),
        // '/profile': (context) => const ProfilePage(), // TODO: when we have it
      },
    );
  }
}
