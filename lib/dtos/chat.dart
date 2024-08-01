
class Message {
  final String event;
  final String value;
  final Map<String, dynamic>? fileData;
  final int createdAt;
  final String senderId;
  final String senderName;
  final String type;

  Message({
    this.value = '',
    required this.createdAt,
    required this.senderId,
    required this.senderName,
    required this.event,
    this.fileData,
    this.type = 'text',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      event: json['event'],
      value: json['value'],
      createdAt: json['created_at'],
      senderId: json['sender']['id'],
      senderName: json['sender']['name'],
      fileData: json['file_data'],
      type: json['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'value': value,
      'created_at': createdAt,
      'data': fileData,
      'sender': {
        'id': senderId,
        'name': senderName,
      },
      'type': type,
    };
  }
}
