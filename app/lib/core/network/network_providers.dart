// lib/core/network/network_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../services/token_service.dart';

/// Dio HTTP client with JWT interceptor
/// The interceptor auto-attaches the Bearer token to every request.
/// When 401 is received, it clears the token (user gets logged out via router).

final dioProvider = Provider<Dio>((ref) {
  final tokenService = ref.watch(tokenServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // JWT Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired or invalid — clear it
          await tokenService.deleteToken();
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});