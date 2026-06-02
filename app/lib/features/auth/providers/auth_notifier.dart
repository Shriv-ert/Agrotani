// lib/features/auth/providers/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

// ── AUTH STATE ────────────────────────────────────────────────────────
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool? isLoading,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ── AUTH NOTIFIER ─────────────────────────────────────────────────────
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> checkAuth() async {
    state = state.copyWith(status: AuthStatus.unknown, isLoading: true);
    try {
      final user = await _repo.getProfile();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } catch (_) {
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.login(email: email, password: password);
      final user = await _repo.getProfile();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
        status: AuthStatus.unauthenticated,
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String address,
    required String email,
    required String password,
    required String aboutMe,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.register(
        name: name,
        phone: phone,
        address: address,
        email: email,
        password: password,
        aboutMe: aboutMe,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
        status: AuthStatus.unauthenticated,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void updateAboutMe(String newAboutMe) {
    if (state.user != null) {
      final updatedUser = state.user!.copyWith(aboutMe: newAboutMe);
      state = state.copyWith(user: updatedUser);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _parseError(Object e) {
    // Coba baca pesan dari response body API (DioException)
    if (e.toString().contains('DioException') || e.runtimeType.toString().contains('Dio')) {
      try {
        // ignore: avoid_dynamic_calls
        final dynamic err = e;
        final responseData = err.response?.data;
        if (responseData is Map && responseData['message'] != null) {
          return responseData['message'].toString();
        }
      } catch (_) {}
    }

    final msg = e.toString();
    if (msg.contains('401')) return 'Email atau password salah';
    if (msg.contains('409') || msg.contains('sudah terdaftar')) return 'Email sudah terdaftar';
    if (msg.contains('400')) return 'Data yang dimasukkan tidak valid';
    if (msg.contains('SocketException') || msg.contains('connection') || msg.contains('Network')) {
      return 'Tidak dapat terhubung ke server. Pastikan WiFi aktif.';
    }
    if (msg.contains('TimeoutException') || msg.contains('timeout')) {
      return 'Koneksi timeout. Coba lagi.';
    }
    return 'Terjadi kesalahan. Coba lagi.';
  }
}

// ── PROVIDERS ─────────────────────────────────────────────────────────
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// Convenience provider — just the user object
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).user;
});
