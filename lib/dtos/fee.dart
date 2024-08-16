import 'package:intl/intl.dart';

class FeeDTO{
  String id;
  DynamicValues? values;
  int action;
  String? consumerId;
  int createdAt;
  int? updatedAt;

  FeeDTO({
    required this.id,
    this.values,
    required this.action,
    this.consumerId,
    required this.createdAt,
  });

  String get createdAtFormated{
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
      return formattedDate;
  }

  String get updatedAtFormated{
    if(updatedAt != null){
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(updatedAt! * 1000);
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
      return formattedDate;
    }else{
      return "-";
    }
  }


  factory FeeDTO.fromJson(Map<String, dynamic> json) {
    return FeeDTO(
      id: json['id'],
      values: json['values'] != null ? DynamicValues.fromJson(json['values']) : null,
      action: json['action'],
      consumerId: json['consumer_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':  id,
      'values': values?.toJson(),
      'action':  action?.toString(),
      'consumer_id': consumerId,
      'created_at':  createdAt.toString(),
    };
  }
}

class DynamicValues {
  double dynamicValue;
  double fixedValue;
  double minDynamicValue;

  DynamicValues({
    required this.dynamicValue,
    required this.fixedValue,
    required this.minDynamicValue,
  });

  factory DynamicValues.fromJson(Map<String, dynamic> json) {
    return DynamicValues(
      dynamicValue: json['dynamic_value'],
      fixedValue: json['fixed_value'],
      minDynamicValue: json['min_dynamic_value']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dynamic_value':  dynamicValue?.toString(),
      'fixed_value': fixedValue?.toString(),
      'min_dynamic_value': minDynamicValue?.toString(),
    };
  }
}
