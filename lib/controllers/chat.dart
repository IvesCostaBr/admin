import 'package:core_dashboard/dtos/suport.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../common/app_config.dart';

class ChatService extends GetxController {
  final Dio _dio;
  final String? baseUrl = AppConfig.instance.websocketBaseUrl;
  final String? apiBaseUrl = AppConfig.instance.apiBaseUrl;
  WebSocketChannel? channel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ChatService(this._dio);

  Future<String?> _getJwtToken() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      return accessToken;
    } catch (e) {
      throw Exception('Falha ao obter token JWT: $e');
    }
  }

  Future<void> connectToWebSocket(String suportId) async {
    final token = await _getJwtToken();
    if (token != null) {
      try {
        if (kIsWeb) {
          final uri = Uri.parse('$baseUrl/api/suport/ws?token=$token&suport_id=$suportId');
          channel = WebSocketChannel.connect(uri);
        } else {
          channel = IOWebSocketChannel.connect('$baseUrl/api/suport/ws?token=$token');
        }
      } catch (e) {
        throw Exception('Erro ao conectar ao WebSocket: $e');
      }
    } else {
      throw Exception('Não foi possível obter o token JWT.');
    }
  }

  Future<List<Support>> getSuports() async {
    final response = await _dio.get("$apiBaseUrl/api/admin/suports");
    List<dynamic> data = response.data;
    final supports = data.map((value) => Support.fromJson(value)).toList();
    return supports;
  }

  void sendMessage(String message) {
    if (channel == null) {
      throw Exception('Conexão WebSocket não está aberta.');
    }
    channel!.sink.add(message);
  }

  void disconnect() {
    channel?.sink.close();
  }
}
