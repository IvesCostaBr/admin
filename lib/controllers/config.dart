import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/dtos/config.dart';
import 'package:core_dashboard/dtos/screens.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ConfigController extends GetxController {
  var appData = Rxn<AppData>();
  final Dio _dio;

  ConfigController(this._dio);

  final String baseurl = AppConfig.instance.apiBaseUrl;

  Future<void> fetchConfig(String consumerId) async {
    try {
      var response = await _dio.get('$baseurl/api/consumers/$consumerId');
      if (response.statusCode == 200) {
        appData.value = AppData.fromJson(response.data["data"]);
      } else {
        throw Exception('Failed to load configuration');
      }
    } catch (e) {
      throw Exception('Error fetching configuration: $e');
    }
  }

  Future<void> upadateGeneralData(Map<String, String> data) async{

  }


  Future<void> upadateThemeData(Map<String, dynamic> data) async{

  }


  void updateScreen(String screenName, Screen updatedScreen) {
  }
}
