import '../../domain/entities/support_conversation_entity.dart';
import 'support_message_model.dart';

class SupportConversationModel extends SupportConversationEntity {
  const SupportConversationModel({
    required String id,
    required String name,
    required String initials,
    required String subtitle,
    required int unreadCount,
    required List<SupportMessageModel> messages,
  }) : super(
         id: id,
         name: name,
         initials: initials,
         subtitle: subtitle,
         unreadCount: unreadCount,
         messages: messages,
       );

  factory SupportConversationModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      initials: json['initials'] as String,
      subtitle: json['subtitle'] as String,
      unreadCount: json['unreadCount'] as int,
      messages: ((json['messages'] as List<dynamic>?) ?? const [])
          .map(
            (item) =>
                SupportMessageModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'subtitle': subtitle,
      'unreadCount': unreadCount,
      'messages': messages
          .map((item) => (item as SupportMessageModel).toJson())
          .toList(),
    };
  }
}
