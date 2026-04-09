import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/support_conversation_entity.dart';
import '../../../domain/entities/support_message_entity.dart';
import '../../../domain/usecases/get_support_conversations_usecase.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final GetSupportConversationsUseCase getSupportConversations;

  List<SupportConversationEntity> _allConversations = const [];
  String _searchQuery = '';
  String? _selectedConversationId;

  SupportBloc({required this.getSupportConversations})
    : super(SupportLoading()) {
    on<LoadSupportData>(_onLoadSupportData);
    on<SearchSupportConversations>(_onSearchSupportConversations);
    on<SelectSupportConversation>(_onSelectSupportConversation);
    on<SendSupportMessage>(_onSendSupportMessage);
  }

  Future<void> _onLoadSupportData(
    LoadSupportData event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());
    final result = await getSupportConversations(NoParams());
    result.fold(
      (failure) => emit(const SupportError('Failed to load support data')),
      (conversations) {
        _allConversations = _sortConversations(conversations);
        _selectedConversationId = conversations.isNotEmpty
            ? _allConversations.first.id
            : null;
        emit(_buildLoadedState());
      },
    );
  }

  void _onSearchSupportConversations(
    SearchSupportConversations event,
    Emitter<SupportState> emit,
  ) {
    _searchQuery = event.query.trim();
    emit(_buildLoadedState());
  }

  void _onSelectSupportConversation(
    SelectSupportConversation event,
    Emitter<SupportState> emit,
  ) {
    _selectedConversationId = event.conversationId;
    emit(_buildLoadedState());
  }

  void _onSendSupportMessage(
    SendSupportMessage event,
    Emitter<SupportState> emit,
  ) {
    if (_selectedConversationId == null || !_isMessageValid(event.message)) {
      return;
    }

    final updatedConversations = <SupportConversationEntity>[];
    SupportConversationEntity? updatedConversation;

    for (final conversation in _allConversations) {
      if (conversation.id != _selectedConversationId) {
        updatedConversations.add(conversation);
        continue;
      }

      updatedConversation = SupportConversationEntity(
        id: conversation.id,
        name: conversation.name,
        initials: conversation.initials,
        subtitle: _buildConversationPreview(event.message),
        unreadCount: 0,
        messages: List<SupportMessageEntity>.from(conversation.messages)
          ..add(event.message),
      );
    }

    if (updatedConversation == null) {
      return;
    }

    _allConversations = [updatedConversation, ...updatedConversations];
    emit(_buildLoadedState());
  }

  bool _isMessageValid(SupportMessageEntity message) {
    if (message.type == SupportMessageType.text) {
      return message.text.trim().isNotEmpty;
    }
    return message.text.trim().isNotEmpty ||
        (message.attachmentName?.trim().isNotEmpty ?? false) ||
        (message.attachmentPath?.trim().isNotEmpty ?? false) ||
        message.options.isNotEmpty;
  }

  String _buildConversationPreview(SupportMessageEntity message) {
    switch (message.type) {
      case SupportMessageType.document:
        return 'Document: ${message.attachmentName ?? message.text}';
      case SupportMessageType.image:
      case SupportMessageType.cameraImage:
        return 'Photo';
      case SupportMessageType.video:
        return 'Video';
      case SupportMessageType.audioFile:
        return 'Audio: ${message.attachmentName ?? message.text}';
      case SupportMessageType.voiceNote:
        return 'Voice note';
      case SupportMessageType.contact:
        return 'Contact: ${message.text}';
      case SupportMessageType.poll:
        return 'Poll: ${message.text}';
      case SupportMessageType.event:
        return 'Event: ${message.text}';
      case SupportMessageType.sticker:
        return 'Sticker';
      case SupportMessageType.text:
        return message.text;
    }
  }

  List<SupportConversationEntity> _sortConversations(
    List<SupportConversationEntity> conversations,
  ) {
    final sorted = List<SupportConversationEntity>.from(conversations);
    sorted.sort((left, right) {
      final leftTime = left.messages.isNotEmpty
          ? left.messages.last.timestamp
          : DateTime.fromMillisecondsSinceEpoch(0);
      final rightTime = right.messages.isNotEmpty
          ? right.messages.last.timestamp
          : DateTime.fromMillisecondsSinceEpoch(0);
      return rightTime.compareTo(leftTime);
    });
    return sorted;
  }

  SupportLoaded _buildLoadedState() {
    final filteredConversations = _searchQuery.isEmpty
        ? _allConversations
        : _allConversations.where((conversation) {
            final query = _searchQuery.toLowerCase();
            return conversation.name.toLowerCase().contains(query) ||
                conversation.subtitle.toLowerCase().contains(query);
          }).toList();

    final availableIds = filteredConversations.map((item) => item.id).toSet();
    final selectedConversationId =
        availableIds.contains(_selectedConversationId)
        ? _selectedConversationId
        : filteredConversations.isNotEmpty
        ? filteredConversations.first.id
        : null;

    _selectedConversationId = selectedConversationId;

    return SupportLoaded(
      conversations: _allConversations,
      filteredConversations: filteredConversations,
      selectedConversationId: selectedConversationId,
    );
  }
}
