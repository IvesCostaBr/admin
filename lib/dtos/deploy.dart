import 'package:intl/intl.dart';

class BaseDTO {
  final int? createdAt;
  final int? updatedAt;

  BaseDTO({this.createdAt, this.updatedAt});


  String get createdAtFormated{
    if(createdAt != null){
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt! * 1000);
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
      return formattedDate;
    }else {
      return "-";
    }
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
}


class DeployDTO extends BaseDTO {
  final String status;
  final String userId;

  DeployDTO({required this.status, required this.userId, required createdAt, updatedAt}) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DeployDTO.fromJson(Map<dynamic, dynamic> json){
    return DeployDTO(status: json['status'], userId: json['user_id'], createdAt: json['created_at'], updatedAt: json['updated_at']);
  }
}