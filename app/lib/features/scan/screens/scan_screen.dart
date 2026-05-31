// lib/features/scan/screens/scan_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../providers/scan_notifier.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  final _picker = ImagePicker();
  bool _isAnalyzing = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil foto. Coba lagi.')),
        );
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;
    setState(() => _isAnalyzing = true);

    final result = await ref
        .read(scanNotifierProvider.notifier)
        .analyze(_selectedImage!);

    if (mounted) {
      setState(() => _isAnalyzing = false);
      if (result != null) {
        context.push(AppRoutes.scanResult, extra: result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analisis gagal. Pastikan foto jelas dan menunjukkan tanaman.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close_rounded, size: 18),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('Scan Tanaman', style: AppTextStyles.headlineSmall),
        centerTitle: false,
      ),
      body: _isAnalyzing
          ? _AnalyzingView()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.screenPadding),
                child: Column(
                  children: [
                    // ── Image Preview Area ──────────────────────────────
                    Expanded(
                      child: _selectedImage == null
                          ? _EmptyImageArea(pulseAnimation: _pulseAnimation)
                          : _ImagePreview(
                              image: _selectedImage!,
                              onClear: () => setState(() => _selectedImage = null),
                            ),
                    ),

                    const SizedBox(height: 20),

                    // ── Action Buttons ──────────────────────────────────
                    if (_selectedImage == null) ...[
                      _SourceButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Ambil Foto',
                        subtitle: 'Gunakan kamera',
                        color: AppColors.primaryLight,
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                      const SizedBox(height: 12),
                      _SourceButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Pilih dari Galeri',
                        subtitle: 'Foto yang sudah ada',
                        color: AppColors.info,
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: _analyzeImage,
                        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                        label: const Text('Analisis dengan AI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: AppTextStyles.buttonText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => setState(() => _selectedImage = null),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Ganti Foto'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),
                    Text(
                      '📸 Pastikan foto jelas dan terang\n🌿 Fokus pada bagian tanaman yang bermasalah',
                      style: AppTextStyles.bodySmall.copyWith(height: 1.7),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
    );
  }
}

// ── Empty Image Area ─────────────────────────────────────────────────────
class _EmptyImageArea extends StatelessWidget {
  final Animation<double> pulseAnimation;
  const _EmptyImageArea({required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, child) => Transform.scale(
        scale: pulseAnimation.value,
        child: child,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryLight.withValues(alpha: 0.3),
            width: 2,
            // Dashed border simulation with decoration
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_rounded,
                size: 44,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih atau ambil foto\ntanaman Anda',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'AI akan menganalisis kondisi tanaman\ndan memberikan diagnosis',
              style: AppTextStyles.bodySmall.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image Preview ─────────────────────────────────────────────────────────
class _ImagePreview extends StatelessWidget {
  final File image;
  final VoidCallback onClear;
  const _ImagePreview({required this.image, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.file(
            image,
            fit: BoxFit.cover,
          ),
        ),
        // Gradient overlay at top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Source Button ──────────────────────────────────────────────────────────
class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.titleMedium),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── Analyzing View ──────────────────────────────────────────────────────────
class _AnalyzingView extends StatefulWidget {
  @override
  State<_AnalyzingView> createState() => _AnalyzingViewState();
}

class _AnalyzingViewState extends State<_AnalyzingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  int _step = 0;
  final _steps = [
    '🔍 Menganalisis foto...',
    '🤖 AI sedang bekerja...',
    '🌿 Mengidentifikasi tanaman...',
    '💊 Menyiapkan rekomendasi...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _rotation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Cycle through steps
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) setState(() => _step = (_step + 1) % _steps.length);
      return mounted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating ring
            AnimatedBuilder(
              animation: _rotation,
              builder: (_, child) => Transform.rotate(
                angle: _rotation.value * 2 * 3.14159,
                child: child,
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _steps[_step],
                key: ValueKey(_step),
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mohon tunggu sebentar...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
