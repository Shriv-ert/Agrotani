// lib/core/network/network_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Your laptop's IP address (Not localhost!)
const String baseUrl = 'http://192.168.1.15:3000/api'; 

// 1. The Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Later, we will add the JWT Token Interceptor right here!
  return dio;
});