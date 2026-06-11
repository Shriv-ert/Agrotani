import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_notifier.dart';
import '../../scan/providers/scan_notifier.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final totalScans = user?.totalScans ?? 0;
    final totalChats = user?.totalChats ?? 0;

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
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur ubah foto profil akan segera hadir')),
                            );
                          },
                          child: Stack(
                            children: [
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
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.primaryLight, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: AppColors.primaryLight,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                          value: '$totalChats',
                          label: 'Sesi Chat',
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Informasi Pribadi ──────────────────────────────────
                  _SectionHeader('Informasi Pribadi'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    children: [
                      _ProfileFieldItem(label: 'Nama', value: user?.name ?? '-'),
                      _ProfileFieldItem(label: 'No. Telepon', value: user?.phone ?? '-'),
                      _ProfileFieldItem(label: 'Alamat', value: user?.address ?? '-'),
                      _ProfileFieldItem(label: 'Username', value: user?.email ?? '-'),
                      _ProfileFieldItem(label: 'Password', value: '••••••••'),
                      _ProfileFieldItem(
                        label: 'Tentang Diri',
                        value: (user?.aboutMe ?? '').isNotEmpty ? user!.aboutMe : 'Belum diisi',
                        showDivider: false,
                        onTap: () => _showEditAboutMeDialog(context, user?.aboutMe ?? ''),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _SectionHeader('Lainnya'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    children: [
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        label: 'Tentang Agrotani',
                        showDivider: false,
                        onTap: () => _showAboutDialog(context),
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

  void _showEditAboutMeDialog(BuildContext context, String currentAboutMe) {
    final controller = TextEditingController(text: currentAboutMe);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.person_outline_rounded, color: AppColors.primaryLight),
            const SizedBox(width: 8),
            Text('Tentang Diri', style: AppTextStyles.headlineSmall),
          ],
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(
            hintText: 'Ceritakan sedikit tentang diri Anda...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAboutMe = controller.text.trim();
              Navigator.pop(dialogContext);
              try {
                await ref.read(authNotifierProvider.notifier).updateAboutMe(newAboutMe);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Tentang diri berhasil diperbarui!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal menyimpan. Coba lagi.'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar?', style: AppTextStyles.headlineSmall),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
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

// ── Profile Field Item ───────────────────────────────────────────────────
class _ProfileFieldItem extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final VoidCallback? onTap;

  const _ProfileFieldItem({
    required this.label,
    required this.value,
    this.showDivider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.right,
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.edit_rounded, size: 14, color: AppColors.primaryLight),
                ]
              ],
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: showDivider
                    ? BorderRadius.zero
                    : BorderRadius.circular(AppConstants.radiusLg),
                child: content,
              )
            : content,
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: AppColors.divider.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}
