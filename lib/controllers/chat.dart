import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../common/app_config.dart';

class WebSocketService {
  final String? baseUrl = AppConfig.instance.websocketBaseUrl;
  WebSocketChannel? channel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getJwtToken() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      return accessToken;
    } catch (e) {
      throw Exception('Falha ao obter token JWT: $e');
    }
  }

  Future<void> connectToWebSocket() async {
    final token = await _getJwtToken();
    if (token != null) {
      try {
        if (kIsWeb) {
          final uri = Uri.parse('$baseUrl/api/suport/ws?token=$token');
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
