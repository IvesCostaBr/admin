import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/dtos/user.dart';
import 'package:core_dashboard/dtos/user/document.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserService extends GetxController {
  final Dio _dio;

  UserService(this._dio);

  final String baseurl = AppConfig.instance.apiBaseUrl;

  Future<List<UserDTO>> getUsers() async {
    final response = await _dio.get("$baseurl/api/admin/users");
    List<dynamic> data = response.data["data"];
    final transactions = data.map((value) => UserDTO.fromJson(value)).toList();
    return transactions;
  }

  Future<List<DocumentDTO>> getDocuments(String id) async {
    final response = await _dio.get("$baseurl/api/admin/users/$id/documents");
    List<dynamic> data = response.data["data"];
    final documents = data.map((value) => DocumentDTO.fromJson(value)).toList();
    return documents;
  }
}