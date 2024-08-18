import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/dtos/event.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class EventService extends GetxController {
  final Dio _dio;

  EventService(this._dio);

  final String baseurl = AppConfig.instance.apiBaseUrl;


  Future<List<EventDTO>> getEvents() async {
    final response = await _dio.get("$baseurl/api/admin/events");
    List<dynamic> data = response.data["data"];
    final events = data.map((value) => EventDTO.fromJson(value)).toList();
    return events;
  }

  Future<bool> sendEvent(Map<String, dynamic> payload) async {
    final response = await _dio.post("$baseurl/api/admin/events/exec", data: payload);
    final data = response.data;
    if(!data["detail"]){
      return false;
    }
    return true;
  }
}