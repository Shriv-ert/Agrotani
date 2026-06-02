// lib/features/scan/data/scan_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';

// --- 1. THE CONTRACT ---
abstract class ScanRepository {
  Future<Map<String, dynamic>> analyzeImage(String imagePath);
}

// --- 2. THE MOCK (Week 1 & 2) ---
class MockScanRepository implements ScanRepository {
  @override
  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    // Fake network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Fake NestJS/Gemini Response
    return {
      "diagnosis": "Bercak Daun Coklat (Brown Spot)",
      "severity": "Sedang",
      "confidence": "89%",
      "recommendation": "1. Potong daun yang sakit\n2. Kurangi penyiraman berlebih\n3. Gunakan fungisida organik."
    };
  }
}

// --- 3. THE REAL API (Week 3) ---
class ApiScanRepository implements ScanRepository {
  final Dio dio;
  ApiScanRepository(this.dio);

  @override
  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    // Pseudo-code for when NestJS is ready
    // final formData = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(imagePath),
    // });
    // final response = await dio.post('/scan/analyze', data: formData);
    // return response.data;
    throw UnimplementedError('API is not ready yet!');
  }
}

// --- 4. THE RIVERPOD SWITCH (The only line you change later) ---
final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  // Right now: Return the Mock
  return MockScanRepository(); 
  
  // When NestJS is ready, comment the line above and uncomment the line below:
  // return ApiScanRepository(ref.watch(dioProvider));
});