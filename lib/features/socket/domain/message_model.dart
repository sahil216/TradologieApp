class Message {
  final String senderId;
  final String message;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "message": message,
        "timestamp": timestamp.toIso8601String(),
      };
}
