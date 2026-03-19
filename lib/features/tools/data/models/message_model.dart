import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required String id,
    required String title,
    required String body,
    required DateTime timestamp,
    bool isRead = false,
  }) : super(
         id: id,
         title: title,
         body: body,
         timestamp: timestamp,
         isRead: isRead,
       );
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}