import '../../domain/entities/support_message_entity.dart';

class SupportMessageModel extends SupportMessageEntity {
  const SupportMessageModel({
    required String id,
    required String text,
    required DateTime timestamp,
    required bool isSentByCurrentUser,
    SupportMessageType type = SupportMessageType.text,
    String? attachmentName,
    String? attachmentPath,
    String? metadata,
    List<String> options = const [],
  }) : super(
         id: id,
         text: text,
         timestamp: timestamp,
         isSentByCurrentUser: isSentByCurrentUser,
         type: type,
         attachmentName: attachmentName,
         attachmentPath: attachmentPath,
         metadata: metadata,
         options: options,
       );

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSentByCurrentUser: json['isSentByCurrentUser'] as bool,
      type: SupportMessageType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => SupportMessageType.text,
      ),
      attachmentName: json['attachmentName'] as String?,
      attachmentPath: json['attachmentPath'] as String?,
      metadata: json['metadata'] as String?,
      options: ((json['options'] as List<dynamic>?) ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isSentByCurrentUser': isSentByCurrentUser,
      'type': type.name,
      'attachmentName': attachmentName,
      'attachmentPath': attachmentPath,
      'metadata': metadata,
      'options': options,
    };
  }
}
