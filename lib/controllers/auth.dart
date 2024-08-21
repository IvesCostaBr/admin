import 'dart:convert';
import 'package:core_dashboard/providers/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../common/app_config.dart';

class AuthService extends GetxController {
  final Dio _dio;
  final String baseUrl = AppConfig.instance.apiBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final userProvider = Get.find<UserProvider>();

  final errorMessage = ''.obs;
  final isLoading = false.obs;

  AuthService(this._dio);

  // Singleton
  static AuthService get to => Get.find<AuthService>();

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _dio.post(
        '${AppConfig.instance.apiBaseUrl}/api/auth/signin',
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        await setAccessToken(data['access_token']);
        isLoading.value = false;
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      errorMessage.value = '${e.response?.data['detail']['error']}';
      isLoading.value = false;
      throw Exception('${e.response?.data['detail']['error']}');
    }
  }

  Future<void> refreshToken() async {
    String? refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken != null) {
      try {
        final response = await _dio.post(
          '${AppConfig.instance.apiBaseUrl}/api/auth/refresh',
          options: Options(
            headers: {"Content-Type": "application/json"},
          ),
          data: jsonEncode({"refresh_token": refreshToken}),
        );

        if (response.statusCode == 200) {
          final data = response.data;
          await setAccessToken(data['access_token']);
        } else {
          throw Exception('Failed to refresh token');
        }
      } catch (e) {
        throw Exception('Failed to refresh token');
      }
    }
  }

  Future<void> changeFirstAccess() async {
    await _dio.put(
      '${AppConfig.instance.apiBaseUrl}/api/users/change-first-access',
    );
  }

  Future<void> autoRefreshToken() async {
    while (true) {
      await Future.delayed(const Duration(minutes: 30)); // ou outra lógica para verificar a validade do token
      await refreshToken();
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/users',
      );
      final data = response.data;
      userProvider.setUserData(data);
      return data;
    } on DioException catch (e) {
      // Verificar se é erro 401 e deslogar usuário
      if (e.response?.statusCode == 401) {
        await logout();
        throw Exception('Failed to fetch user data: Unauthorized');
      } else {
        throw Exception('${e.response?.data ?? e.message}');
      }
    }
  }
}
