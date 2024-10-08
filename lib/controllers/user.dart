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

  Future<List<UserDTO>> getUsersAdmin() async {
    final response = await _dio.get("$baseurl/api/admin/users?admin=true");
    List<dynamic> data = response.data["data"];
    final usersAdmin = data.map((value) => UserDTO.fromJson(value)).toList();
    return usersAdmin;
  }

  Future<bool> createUserAdmin(Map<String, dynamic> data) async {
    try{
      await _dio.post(
        "$baseurl/api/admin/users",
        data: data
      );
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> updateStatusDocument(String docid, int newStatus) async {
    try{
      await _dio.put(
        "$baseurl/api/admin/users/documents/$docid?new_status=$newStatus",
      );
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> changeUserStaus(String userId, int newStatus) async {
    try{
      await _dio.put(
        "$baseurl/api/admin/users/$userId/status?new_status=$newStatus",
      );
      return true;
    }catch(e){
      return false;
    }
  }
}