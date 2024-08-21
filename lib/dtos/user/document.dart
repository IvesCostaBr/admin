import 'package:intl/intl.dart';

class DocumentDTO {
  final String id;
  final String userId;
  final String name;
  final Map<String, dynamic> data;
  final int createdAt;
  final int? updatedAt;
  final bool isValidated;

  DocumentDTO({required this.id, required this.userId, required this.name, required this.data, required this.createdAt, required this.updatedAt, required this.isValidated});

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
      return "";
    }
  }

  factory DocumentDTO.fromJson(Map<dynamic, dynamic> json){
    return DocumentDTO(
      id: json['id'],
      userId: json["user_id"],
      name: json["name"],
      data: json["data"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      isValidated: json["is_validated"]
    );
  }
}