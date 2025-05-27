import 'package:flutter/material.dart';
import 'package:sad_final/log_in_page.dart';
import 'package:sad_final/splash_screen.dart';

void main() {
  runApp(const MovixApp());
}

class MovixApp extends StatelessWidget {
  const MovixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Movix',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
