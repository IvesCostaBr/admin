import 'package:core_dashboard/common/app_config.dart';
import 'package:core_dashboard/dtos/transaction.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TransactionService extends GetxController {
  final Dio _dio;

  TransactionService(this._dio);

  final String baseurl = AppConfig.instance.apiBaseUrl;


  Future<List<TransactionDTO>> getTransactions() async {
    final response = await _dio.get("$baseurl/api/admin/transactions");
    List<dynamic> data = response.data["data"];
    final transactions = data.map((value) => TransactionDTO.fromJson(value)).toList();
    return transactions;
  }
}