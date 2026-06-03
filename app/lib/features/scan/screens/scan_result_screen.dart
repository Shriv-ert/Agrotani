// lib/features/scan/screens/scan_result_screen.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../data/scan_result_model.dart';
import '../providers/scan_notifier.dart';
import '../../chat/providers/chat_notifier.dart';

class ScanResultScreen extends ConsumerStatefulWidget {
  final ScanResultModel? scanResult;
  const ScanResultScreen({super.key, this.scanResult});

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends ConsumerState<ScanResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  String? _submittedFeedback;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  ScanResultModel? get _scan =>
      widget.scanResult ?? ref.read(scanNotifierProvider).value;

  @override
  Widget build(BuildContext context) {
    final scan = _scan;

    if (scan == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Data tidak ditemukan', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      );
    }

    final severityColor = _getSeverityColor(scan.severity);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Image Header ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryLight,
            leading: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                ),
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageHeader(scan),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Diagnosis Header ──────────────────────────────
                      _DiagnosisHeaderCard(
                        scan: scan,
                        severityColor: severityColor,
                      ),

                      const SizedBox(height: 16),

                      // ── Recommendation ────────────────────────────────
                      _RecommendationCard(recommendation: scan.recommendation),

                      const SizedBox(height: 16),

                      // ── Feedback ──────────────────────────────────────
                      _FeedbackCard(
                        scanId: scan.id,
                        currentFeedback: _submittedFeedback ?? scan.feedback,
                        onFeedback: (feedback) {
                          setState(() => _submittedFeedback = feedback);
                          ref.read(scanHistoryProvider.notifier).submitFeedback(scan.id, feedback);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(feedback == 'accurate'
                                  ? '✅ Terima kasih! Feedback Anda membantu kami berkembang.'
                                  : '📝 Terima kasih! Kami akan terus meningkatkan akurasi AI.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // ── Actions ───────────────────────────────────────
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(scanNotifierProvider.notifier).reset();
                          context.pop();
                        },
                        icon: const Icon(Icons.camera_alt_rounded, size: 20),
                        label: const Text('Scan Tanaman Lain'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          ref.read(chatNotifierProvider.notifier).setScanContext(scan);
                          context.go(AppRoutes.chat);
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                        label: const Text('Tanya FarmerBot'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader(ScanResultModel scan) {
    final isLocalPath = scan.imageUrl.startsWith('/') || scan.imageUrl.startsWith('file://');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        if (isLocalPath)
          kIsWeb
              ? Image.network(scan.imageUrl, fit: BoxFit.cover)
              : Image.file(File(scan.imageUrl), fit: BoxFit.cover)
        else
          Container(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: const Center(
              child: Icon(Icons.eco_rounded, size: 80, color: Colors.white),
            ),
          ),

        // Bottom gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    final lowerSev = severity.toLowerCase();
    if (lowerSev.contains('parah') || lowerSev.contains('tinggi')) {
      return AppColors.severityHigh;
    } else if (lowerSev.contains('sedang')) {
      return AppColors.severityMedium;
    } else {
      return AppColors.severityLow;
    }
  }
}

// ── Diagnosis Header Card ────────────────────────────────────────────────
class _DiagnosisHeaderCard extends StatelessWidget {
  final ScanResultModel scan;
  final Color severityColor;

  const _DiagnosisHeaderCard({required this.scan, required this.severityColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.primaryLight),
                    const SizedBox(width: 4),
                    Text(
                      'Diagnosis AI',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Severity Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: severityColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 14, color: severityColor),
                    const SizedBox(width: 4),
                    Text(
                      scan.severity,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: severityColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('🔍 Diagnosis', style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(scan.diagnosis, style: AppTextStyles.diagnosisTitle),
          const SizedBox(height: 16),
          // Confidence bar
          Row(
            children: [
              Text('Keyakinan AI:', style: AppTextStyles.bodySmall),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _parseConfidence(scan.confidence),
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                scan.confidence,
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _parseConfidence(String confidence) {
    final numeric = confidence.replaceAll('%', '');
    return (double.tryParse(numeric) ?? 0) / 100;
  }
}

// ── Recommendation Card ──────────────────────────────────────────────────
class _RecommendationCard extends StatelessWidget {
  final String recommendation;
  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final lines = recommendation
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.medication_rounded, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 10),
              Text('💊 Rekomendasi', style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: 16),
          ...lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        line.replaceFirst(RegExp(r'^[•\-\*\d+\.]\s*'), ''),
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Feedback Card ────────────────────────────────────────────────────────
class _FeedbackCard extends StatelessWidget {
  final String scanId;
  final String? currentFeedback;
  final void Function(String feedback) onFeedback;

  const _FeedbackCard({
    required this.scanId,
    required this.currentFeedback,
    required this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    if (currentFeedback != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.primaryLight, size: 20),
            const SizedBox(width: 8),
            Text(
              'Terima kasih atas feedback Anda!',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryLight),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Apakah diagnosis ini akurat?', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onFeedback('accurate'),
                  icon: const Icon(Icons.thumb_up_rounded, size: 16),
                  label: const Text('Ya, akurat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(color: AppColors.primaryLight),
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onFeedback('inaccurate'),
                  icon: const Icon(Icons.thumb_down_rounded, size: 16),
                  label: const Text('Tidak akurat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
