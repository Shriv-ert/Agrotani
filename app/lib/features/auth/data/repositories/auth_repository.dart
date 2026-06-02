// lib/features/auth/data/repositories/auth_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/network_providers.dart'; // ← untuk dioProvider
import '../models/user_model.dart';

// ── 1. THE CONTRACT (Interface) ───────────────────────────────────────
abstract class AuthRepository {
  Future<String> login({required String email, required String password});
  Future<String> register({
    required String name,
    required String phone,
    required String address,
    required String username,
    required String password,
    required String aboutMe,
  });
  Future<UserModel> getProfile();
  Future<void> logout();
}

// ── 2. MOCK IMPLEMENTATION (Use this while backend is being built) ────
class MockAuthRepository implements AuthRepository {
  final TokenService tokenService;

  MockAuthRepository(this.tokenService);

  @override
  Future<String> login({required String email, required String password}) async {
    await Future.delayed(AppConstants.mockDelay);

    // Simulate validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password tidak boleh kosong');
    }
    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    const fakeToken = 'mock-jwt-token-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';
    await tokenService.saveToken(fakeToken);
    return fakeToken;
  }

  UserModel? _registeredUser;

  @override
  Future<String> register({
    required String name,
    required String phone,
    required String address,
    required String username,
    required String password,
    required String aboutMe,
  }) async {
    await Future.delayed(AppConstants.mockDelay);

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      throw Exception('Semua field wajib diisi');
    }
    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    _registeredUser = UserModel(
      id: 'mock-user-002',
      name: name,
      email: username,
      phone: phone,
      address: address,
      aboutMe: aboutMe,
    );

    return 'registered_successfully';
  }

  @override
  Future<UserModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final tokenExists = await tokenService.hasToken();
    if (!tokenExists) {
      throw Exception('Tidak ada token, user belum login');
    }
    return _registeredUser ?? UserModel.mock;
  }

  @override
  Future<void> logout() async {
    await tokenService.clearAll();
  }
}

// ── 3. REAL API IMPLEMENTATION (Uncomment when backend is ready) ──────
class ApiAuthRepository implements AuthRepository {
  final Dio dio;
  final TokenService tokenService;

  ApiAuthRepository(this.dio, this.tokenService);

  @override
  Future<String> login({required String email, required String password}) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final token = response.data['accessToken'] as String;
    await tokenService.saveToken(token);
    return token;
  }

  @override
  Future<String> register({
    required String name,
    required String phone,
    required String address,
    required String username,
    required String password,
    required String aboutMe,
  }) async {
    await dio.post('/auth/register', data: {
      'name': name,
      'phone': phone,
      'address': address,
      'username': username,
      'password': password,
      'aboutMe': aboutMe,
    });
    // Do not save token here, let user login manually
    return 'registered';
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await dio.get('/auth/profile');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await tokenService.clearAll();
  }
}

// ── 4. PROVIDER SWITCH ─────────────────────────────────────────────────
// ✅ Flip this ONE line to switch Mock ↔ Real API
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenService = ref.watch(tokenServiceProvider);

  // 👇 REAL: Connected to NestJS backend
  return ApiAuthRepository(ref.watch(dioProvider), tokenService);

  // 👇 MOCK: Uncomment to go back to mock during development
  // return MockAuthRepository(tokenService);
});
