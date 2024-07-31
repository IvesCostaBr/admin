class Message {
  final String event;
  final String value;
  final int createdAt;
  final String senderId;
  final String senderName;

  Message({
    required this.value,
    required this.createdAt,
    required this.senderId,
    required this.senderName,
    required this.event,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      event: json['event'],
      value: json['value'],
      createdAt: json['created_at'],
      senderId: json['sender']['id'],
      senderName: json['sender']['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'value': value,
      'created_at': createdAt,
      'sender': {
        'id': senderId,
        'name': senderName,
      },
    };
  }
}
