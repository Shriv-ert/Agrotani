// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_notifier.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/scan/screens/scan_screen.dart';
import '../../features/scan/screens/scan_result_screen.dart';
import '../../features/scan/data/scan_result_model.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../widgets/main_shell.dart';

// Route name constants — avoid typo bugs
class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const scan = '/scan';
  static const scanResult = '/scan/result';
  static const chat = '/chat';
  static const profile = '/profile';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true, // Remove in production
    redirect: (context, state) {
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnAuth = state.matchedLocation == AppRoutes.welcome ||
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Still checking auth — stay on splash
      if (authState.status == AuthStatus.unknown) {
        return isOnSplash ? null : AppRoutes.splash;
      }

      // Not authenticated — go to welcome (unless already on auth screens)
      if (authState.status == AuthStatus.unauthenticated) {
        return isOnAuth ? null : AppRoutes.welcome;
      }

      // Authenticated — go to home (if on auth/splash screens)
      if (authState.status == AuthStatus.authenticated) {
        if (isOnSplash || isOnAuth) return AppRoutes.home;
      }

      return null; // No redirect needed
    },
    routes: [
      // ── SPLASH ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),

      // ── AUTH ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WelcomeScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: _slideUpTransition,
        ),
      ),

      // ── MAIN SHELL (Bottom Nav) ──────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.chat,
            builder: (_, __) => const ChatScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      // ── SCAN (Full screen — outside shell) ───────────────────────
      GoRoute(
        path: AppRoutes.scan,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ScanScreen(),
          transitionsBuilder: _slideUpTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.scanResult,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) {
          final scan = state.extra as ScanResultModel?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScanResultScreen(scanResult: scan),
            transitionsBuilder: _slideUpTransition,
          );
        },
      ),
    ],
  );
});

// ── Transition Builders ────────────────────────────────────────────────
Widget _fadeTransition(_, Animation<double> animation, __, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideUpTransition(
  _,
  Animation<double> animation,
  __,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
    child: FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
  );
}
