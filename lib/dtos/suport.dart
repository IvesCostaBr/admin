enum SuportStatus {completed, open}


class Support {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String status;
  final Map<String, dynamic> owner;
  final Map<String, dynamic>? admin;
  final Map<String, dynamic>? messages;

  Support({required this.id, this.createdAt, this.updatedAt, required this.owner, required this.status, this.messages, this.admin});

  factory Support.empty(){
    return Support(id: "", status: "", owner: {});
  }

  factory Support.fromJson(Map<String, dynamic> json){
    return Support(
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.fromMillisecondsSinceEpoch(json['updated_at']) : null,
      messages: json['messages'],
      admin: json['admin'],
      owner: json["owner"] ?? {}
    );
  }
}