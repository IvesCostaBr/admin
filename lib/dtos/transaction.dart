import 'package:intl/intl.dart';

class PersonData {
  final String? name;
  final String? document;
  final String? userId;
  final Map<dynamic, dynamic>? accountData;

  PersonData({this.name,this.document,this.accountData, this.userId});

  factory PersonData.fromJson(Map<dynamic, dynamic> json){
    return PersonData(
      accountData: json['account_data'],
      name: json['account_data'],
      document: json['document'],
      userId: json['userId']
    );
  }
}



class TransactionDTO {
  final String id;
  final String action;
  final double amount;
  final int createdAt;
  final int? updatedAt;
  final int type;
  final int status;
  final String? description;
  final PersonData? payer;
  final PersonData? receiver;
  final Map<dynamic, dynamic>? depositData;
  final Map<dynamic, dynamic>? data;

  TransactionDTO({required this.id, required this.action, required this.amount, required this.type, required this.status, required this.description, required this.payer, required this.receiver, required this.depositData, required this.data, required this.createdAt, this.updatedAt});

    String get typeFormated{
    switch (type){
      case 0:
        return "CRIPTO";
      case 1:
        return "PIX";
      case 2:
        return "TRANSFERÊNCIA";
      case 3:
        return "COBRANÇA";
      default:
        return "";
    }
  }

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

  String get generateDescription {
    if (type == 0 && action == "CASH_OUT"){
      return "SAQUE DE CRIPTO";
    }else if(type == 0 && action == "CASH_IN"){
      return "DEPOSITO DE CRIPTO";
    }else{
      return "-";
    }
  }
  
  String get statusFormated{
    switch (status){
      case 0:
        return "AGUARDANDO PAGAMENTO";
      case 1:
        return "CONFIRMADO";
      case 2:
        return "PROCESSANDO";
      case 3:
        return "CANCELADO";
      case 4:
        return "ERRO";
      default:
        return "";
    }
  }

  factory TransactionDTO.fromJson(Map<dynamic, dynamic> json){
    return TransactionDTO(
      id: json['id'],
      action: json['action'],
      amount: json['amount'],
      data: json['data'],
      depositData: json['deposit_data'],
      description: json['description'],
      type: json['type'],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      status: json['status'],
      receiver: json['receiver'] != null ? PersonData.fromJson(json['receiver']) : null,
      payer: json['payer'] != null ? PersonData.fromJson(json['payer']) : null
    );
  }

}