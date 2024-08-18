import 'dart:convert';

class EventDTO {
  final String name;
  final String description;
  final String image;
  final List<String> requiredFields;
  final int id;
  final DateTime createdAt;

  EventDTO({
    required this.name,
    required this.description,
    required this.image,
    required this.requiredFields,
    required this.id,
    required this.createdAt,
  });

  // Factory constructor to create an instance from JSON
  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      requiredFields: List<String>.from(json['required_fields']),
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'required_fields': requiredFields,
      'id': id,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
