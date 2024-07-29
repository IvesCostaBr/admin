import 'package:core_dashboard/common/looger.dart';
import 'package:core_dashboard/common/routes_config.dart';
import 'package:core_dashboard/controllers/auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

final Dio dio = Dio();

void setupDio() {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        const storage = FlutterSecureStorage();
        String? accessToken = await storage.read(key: 'access_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        // Log da requisição
        logger.i('REQUEST: ${options.method} ${options.uri}');
        logger.i('REQUEST HEADERS: ${options.headers}');
        logger.i('REQUEST BODY: ${options.data}');
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Log da resposta
        logger.i('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
        logger.i('RESPONSE DATA: ${response.data}');
        
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // Log do erro
        logger.e('ERROR: ${e.response?.statusCode} ${e.requestOptions.uri}');
        logger.e('ERROR MESSAGE: ${e.message}');
        
        // Verificar se o erro é 401 e deslogar usuário
        if (e.response?.statusCode == 401) {
          final authService = Get.find<AuthService>(); // Injeta o Dio na AuthService
          await authService.logout();
          Get.toNamed(AppRouter.signIn);
        }
        
        return handler.next(e);
      },
    ),
  );
}
