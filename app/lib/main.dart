// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 1. ADD THIS IMPORT SO MAIN.DART KNOWS ABOUT YOUR NEW SCREEN
import 'features/scan/screens/test_scan_screen.dart'; 

void main() {
  runApp(const ProviderScope(child: AgrotaniApp()));
}

class AgrotaniApp extends StatelessWidget {
  const AgrotaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrotani',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      // 2. CHANGE THIS LINE TO POINT TO YOUR NEW SCREEN
      home: const TestScanScreen(), 
    );
  }
}