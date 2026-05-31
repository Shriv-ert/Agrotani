// lib/core/widgets/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../router/app_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _AgrotaniBottomNav(),
    );
  }
}

class _AgrotaniBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.8),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                activeIcon: Icons.home_rounded,
                label: 'Beranda',
                onTap: () => context.go(AppRoutes.home),
              ),
              // Center Scan FAB-style button
              _ScanNavButton(
                onTap: () => context.push(AppRoutes.scan),
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'FarmerBot',
                onTap: () => context.go(AppRoutes.chat),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.scan)) return 1;
    if (location.startsWith(AppRoutes.chat)) return 2;
    return 0;
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primarySoft
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.navLabel.copyWith(
                  color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Center scan button — styled as a FAB-style pill
class _ScanNavButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ScanNavButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryLight.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.document_scanner_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Scan',
            style: AppTextStyles.navLabel.copyWith(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
