import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/dtos/fee.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class FeeService extends GetxController {
  final Dio _dio;
  final String baseurl = AppConfig.instance.apiBaseUrl;

  FeeService(this._dio);


  Future<List<FeeDTO>> getFees() async {
    final response = await _dio.get("$baseurl/api/admin/fees");
    List<dynamic> data = response.data["data"];
    final fees = data.map((value) => FeeDTO.fromJson(value)).toList();
    return fees;
  }

  Future<bool> updateFee(String id, Map<String, dynamic> data) async {
    final response = await _dio.put("$baseurl/api/admin/fees");
    if(response.statusCode != 200){
      return false;
    }
    return true;
  }
  
}