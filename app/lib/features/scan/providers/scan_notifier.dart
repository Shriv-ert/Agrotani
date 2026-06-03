// lib/features/scan/providers/scan_notifier.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/scan_result_model.dart';
import '../data/scan_repository.dart';

// ── SCAN ANALYSIS NOTIFIER ────────────────────────────────────────────
// Controls the "take photo → analyze → show result" flow
class ScanNotifier extends Notifier<AsyncValue<ScanResultModel?>> {
  @override
  AsyncValue<ScanResultModel?> build() => const AsyncValue.data(null);

  Future<ScanResultModel?> analyze(XFile imageFile) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(scanRepositoryProvider);
      final result = await repo.analyzeImage(imageFile);
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final scanNotifierProvider =
    NotifierProvider<ScanNotifier, AsyncValue<ScanResultModel?>>(() {
  return ScanNotifier();
});

// ── SCAN HISTORY NOTIFIER ─────────────────────────────────────────────
class ScanHistoryNotifier extends AsyncNotifier<List<ScanResultModel>> {
  @override
  Future<List<ScanResultModel>> build() async {
    return _loadHistory();
  }

  Future<List<ScanResultModel>> _loadHistory() {
    return ref.read(scanRepositoryProvider).getHistory();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadHistory());
  }

  Future<void> submitFeedback(String scanId, String feedback) async {
    await ref.read(scanRepositoryProvider).submitFeedback(scanId, feedback);
    // Update local state
    state.whenData((list) {
      state = AsyncValue.data(
        list.map((s) => s.id == scanId ? s.copyWith(feedback: feedback) : s).toList(),
      );
    });
  }
}

final scanHistoryProvider =
    AsyncNotifierProvider<ScanHistoryNotifier, List<ScanResultModel>>(() {
  return ScanHistoryNotifier();
});

// Convenience: recent 3 scans for home screen
final recentScansProvider = Provider<List<ScanResultModel>>((ref) {
  return ref.watch(scanHistoryProvider).maybeWhen(
        data: (list) => list.take(3).toList(),
        orElse: () => [],
      );
});
