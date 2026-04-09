import '../models/support_conversation_model.dart';
import '../models/support_message_model.dart';
import '../../domain/entities/support_message_entity.dart';

abstract class SupportRemoteDataSource {
  Future<List<SupportConversationModel>> getSupportConversations();
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  @override
  Future<List<SupportConversationModel>> getSupportConversations() async {
    return [
      SupportConversationModel(
        id: 'admin59',
        name: 'Admin59',
        initials: 'A',
        subtitle: 'Help me for Trade',
        unreadCount: 0,
        messages: [
          SupportMessageModel(
            id: 'm1',
            text:
                'I\'m creating a template with various paragraph styles and need to see what they will look like.',
            timestamp: DateTime(2025, 10, 26, 9, 41),
            isSentByCurrentUser: false,
            type: SupportMessageType.text,
          ),
          SupportMessageModel(
            id: 'm2',
            text:
                'I\'m creating a template with various paragraph styles and need to see what they will look like.',
            timestamp: DateTime(2025, 10, 26, 9, 41),
            isSentByCurrentUser: true,
            type: SupportMessageType.text,
          ),
          SupportMessageModel(
            id: 'm3',
            text:
                'I\'m creating a template with various paragraph styles and need to see what they will look like.',
            timestamp: DateTime(2025, 10, 27, 9, 41),
            isSentByCurrentUser: true,
            type: SupportMessageType.text,
          ),
        ],
      ),
      SupportConversationModel(
        id: 'jitu-mh-1',
        name: 'Jitu bhai & Sons (MH)',
        initials: 'C',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: [
          SupportMessageModel(
            id: 'm4',
            text: 'Please check margin calculation for my client login.',
            timestamp: DateTime(2025, 10, 27, 10, 12),
            isSentByCurrentUser: false,
            type: SupportMessageType.text,
          ),
        ],
      ),
      SupportConversationModel(
        id: 'jitu-mh-2',
        name: 'Jitu bhai & Sons (MH)',
        initials: 'C',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'mona-tailor',
        name: 'Mona tailor',
        initials: 'M',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'jenifer-methew',
        name: 'Jenifer Methew',
        initials: 'M',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'jitu-tl-1',
        name: 'Jitu bhai & Sons (TL)',
        initials: 'C',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'janaki-1',
        name: 'Janaki Desai',
        initials: 'C',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'jitu-tl-2',
        name: 'Jitu bhai & Sons (TL)',
        initials: 'M',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'janaki-2',
        name: 'Janaki Desai',
        initials: 'M',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
      SupportConversationModel(
        id: 'jitu-tl-3',
        name: 'Jitu bhai & Sons (TL)',
        initials: 'M',
        subtitle: 'Help me for Trade',
        unreadCount: 20,
        messages: const [],
      ),
    ];
  }
}
