import 'package:equatable/equatable.dart';

import 'support_message_entity.dart';

class SupportConversationEntity extends Equatable {
  final String id;
  final String name;
  final String initials;
  final String subtitle;
  final int unreadCount;
  final List<SupportMessageEntity> messages;

  const SupportConversationEntity({
    required this.id,
    required this.name,
    required this.initials,
    required this.subtitle,
    required this.unreadCount,
    required this.messages,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    initials,
    subtitle,
    unreadCount,
    messages,
  ];
}
