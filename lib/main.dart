import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'profile/profile_screen.dart';
import 'pin_screen.dart'; // Import file pin_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      initialRoute: '/',
      // Tidak perlu menambahkan MyHomePage di sini
    );
  }
}
