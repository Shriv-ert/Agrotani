import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_notifier.dart';
import '../../scan/providers/scan_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final historyAsync = ref.watch(scanHistoryProvider);
    final totalScans = historyAsync.value?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryLight,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 3,
                            ),
                          ),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.name ?? 'Petani Agrotani',
                          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'email@agrotani.id',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: Column(
                children: [
                  // ── Stats Row ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.document_scanner_rounded,
                          value: '$totalScans',
                          label: 'Total Scan',
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.chat_bubble_rounded,
                          value: '1',
                          label: 'Sesi Chat',
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.star_rounded,
                          value: _getAccuracyRate(historyAsync.value),
                          label: 'Akurasi',
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Menu Items ─────────────────────────────────────────
                  _SectionHeader('Akun'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    children: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Edit Profil',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        label: 'Ubah Password',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifikasi',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Segera',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _SectionHeader('Tentang Aplikasi'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    children: [
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        label: 'Tentang Agrotani',
                        onTap: () => _showAboutDialog(context),
                      ),
                      _MenuItem(
                        icon: Icons.star_outline_rounded,
                        label: 'Beri Rating',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.bug_report_outlined,
                        label: 'Laporkan Bug',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Logout ─────────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    child: _MenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Keluar',
                      iconColor: AppColors.error,
                      labelColor: AppColors.error,
                      showDivider: false,
                      onTap: () => _confirmLogout(context, ref),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Agrotani v1.0.0 — MVP Build',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAccuracyRate(List<dynamic>? scans) {
    if (scans == null || scans.isEmpty) return '-';
    return '89%'; // Mock
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.eco_rounded, color: AppColors.primaryLight),
            const SizedBox(width: 8),
            Text('Agrotani', style: AppTextStyles.headlineSmall),
          ],
        ),
        content: Text(
          'Aplikasi diagnosis tanaman berbasis AI untuk petani Indonesia.\n\n'
          'Menggunakan Gemini AI untuk menganalisis foto tanaman dan memberikan rekomendasi penanganan.\n\n'
          'Versi: 1.0.0 (MVP)\nDibuat untuk: Proyek Akhir Semester',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar?', style: AppTextStyles.headlineSmall),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).logout();
              // Router redirect handles navigation to login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.headlineMedium.copyWith(color: color)),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
    );
  }
}

// ── Menu Card ────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Column(children: children),
    );
  }
}

// ── Menu Item ────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final Widget? trailing;
  final bool showDivider;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: labelColor ?? AppColors.textPrimary,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.textDisabled,
                    ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 52,
            color: AppColors.divider.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}
