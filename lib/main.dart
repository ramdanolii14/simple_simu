// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SiMuApp());
}

class SiMuApp extends StatelessWidget {
  const SiMuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiMu - Keuangan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A6BFF),
          primary: const Color(0xFF1A6BFF),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}