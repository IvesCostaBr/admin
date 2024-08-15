class UserDTO {
  final String? name;
  final String? document;
  final String email;
  final String? birthData;
  final String consumerId;
  final double? createdAt;
  final bool isAdmin;
  final String id;
  final String? avatar;

  UserDTO({
    required this.name,
    required this.document,
    required this.email,
    required this.birthData,
    required this.consumerId,
    this.createdAt,
    required this.id,
    required this.isAdmin,
    this.avatar
  });

  // Método para converter de JSON para o objeto UserDTO
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      name: json['name'],
      document: json['document'],
      email: json['email'],
      birthData: json['birth_data'],
      consumerId: json['consumer_id'],
      createdAt: json['created_at'],
      id: json['id'],
      avatar: json['avatar'],
      isAdmin: json['is_admin'] ?? false
    );
  }

  // Método para converter o objeto UserDTO para JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'document': document,
      'email': email,
      'birth_data': birthData,
      'consumer_id': consumerId,
      'created_at': createdAt,
      'id': id,
    };
  }
}