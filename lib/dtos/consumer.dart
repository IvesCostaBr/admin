import 'package:core_dashboard/dtos/deploy.dart';

class MinimunConsumer extends BaseDTO {
  final String id;
  final String name;
  final String status;
  @override
  final int? createdAt;
  @override
  final int? updatedAt;

  MinimunConsumer({
    required this.id,
    required this.name,
    required this.status,
    this.createdAt,
    this.updatedAt
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  // Factory constructor para criar uma instância de MinimunConsumer a partir de um JSON
  factory MinimunConsumer.fromJson(Map<String, dynamic> json) {
    return MinimunConsumer(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Método para converter a instância de MinimunConsumer em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}