// lib/features/scan/screens/test_scan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/scan_repository.dart';

// --- 1. MODERN RIVERPOD STATE MANAGEMENT ---
// This controller handles the API call and the state simultaneously.
class ScanController extends Notifier<AsyncValue<Map<String, dynamic>?>> {
  @override
  AsyncValue<Map<String, dynamic>?> build() {
    return const AsyncValue.data(null); // Initial state: no data, not loading
  }

  Future<void> runMockScan() async {
    state = const AsyncValue.loading(); // UI instantly updates to show loading spinner
    
    try {
      final repo = ref.read(scanRepositoryProvider);
      final result = await repo.analyzeImage('/fake/path/to/image.jpg');
      state = AsyncValue.data(result); // UI updates with the success data
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // UI updates with error text
    }
  }
}

// Create the provider for the controller
final scanControllerProvider = NotifierProvider<ScanController, AsyncValue<Map<String, dynamic>?>>(() {
  return ScanController();
});

// --- 2. THE UI ---
class TestScanScreen extends ConsumerWidget {
  const TestScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the AsyncValue state
    final scanState = ref.watch(scanControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Mock Scan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AsyncValue's .when() forces you to handle all 3 states perfectly!
              scanState.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
                data: (scanResult) {
                  if (scanResult == null) {
                    return const Text('Belum ada hasil scan.');
                  }
                  return Column(
                    children: [
                      Text('Diagnosis: ${scanResult["diagnosis"]}', 
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Keparahan: ${scanResult["severity"]}', 
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      Text(scanResult["recommendation"], textAlign: TextAlign.center),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton.icon(
                // Disable button if currently loading
                onPressed: scanState.isLoading 
                    ? null 
                    : () => ref.read(scanControllerProvider.notifier).runMockScan(),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Simulasi Scan Tanaman'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}