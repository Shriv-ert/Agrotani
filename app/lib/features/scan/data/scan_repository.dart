// lib/features/scan/data/scan_repository.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import '../../../../core/network/network_providers.dart'; // Used by ApiScanRepository
import 'scan_result_model.dart';

import 'package:image_picker/image_picker.dart';

// ── 1. THE CONTRACT ────────────────────────────────────────────────────
abstract class ScanRepository {
  Future<ScanResultModel> analyzeImage(XFile imageFile);
  Future<List<ScanResultModel>> getHistory({int limit = 10});
  Future<ScanResultModel> getScanById(String id);
  Future<void> submitFeedback(String scanId, String feedback);
}

// ── 2. MOCK IMPLEMENTATION ────────────────────────────────────────────
class MockScanRepository implements ScanRepository {
  // In-memory store for demo
  final List<ScanResultModel> _history = List.from(ScanResultModel.mockHistory);

  @override
  Future<ScanResultModel> analyzeImage(XFile imageFile) async {
    // Simulate AI analysis delay
    await Future.delayed(const Duration(seconds: 3));

    // Rotate through different diagnoses for demo variety
    final index = DateTime.now().second % ScanResultModel.mockHistory.length;
    final mockBase = ScanResultModel.mockHistory[index];

    final newScan = mockBase.copyWith(
      id: 'scan-${DateTime.now().millisecondsSinceEpoch}',
      imageUrl: imageFile.path,
      createdAt: DateTime.now(),
      feedback: null,
    );

    _history.insert(0, newScan);
    return newScan;
  }

  @override
  Future<List<ScanResultModel>> getHistory({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _history.take(limit).toList();
  }

  @override
  Future<ScanResultModel> getScanById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _history.firstWhere(
      (s) => s.id == id,
      orElse: () => ScanResultModel.mockSingle,
    );
  }

  @override
  Future<void> submitFeedback(String scanId, String feedback) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Update in-memory
    final idx = _history.indexWhere((s) => s.id == scanId);
    if (idx != -1) {
      _history[idx] = _history[idx].copyWith(feedback: feedback);
    }
  }
}

// ── 3. REAL API IMPLEMENTATION ─────────────────────────────────────────
class ApiScanRepository implements ScanRepository {
  final Dio dio;

  ApiScanRepository(this.dio);

  @override
  Future<ScanResultModel> analyzeImage(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        bytes,
        filename: imageFile.name.isNotEmpty ? imageFile.name : 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    });
    final response = await dio.post('/scan/analyze', data: formData);
    return ScanResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ScanResultModel>> getHistory({int limit = 10}) async {
    final response = await dio.get('/scan/history', queryParameters: {'limit': limit});
    final list = response.data as List;
    return list.map((e) => ScanResultModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ScanResultModel> getScanById(String id) async {
    final response = await dio.get('/scan/$id');
    return ScanResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> submitFeedback(String scanId, String feedback) async {
    await dio.post('/scan/$scanId/feedback', data: {'feedback': feedback});
  }
}

// ── 4. PROVIDER SWITCH ──────────────────────────────────────────────────
// ✅ ONE LINE TOGGLE — Mock ↔ Real API
final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  // 👇 REAL: Connected to NestJS backend
  return ApiScanRepository(ref.watch(dioProvider));

  // 👇 MOCK: Uncomment to go back to mock during development
  // return MockScanRepository();
});