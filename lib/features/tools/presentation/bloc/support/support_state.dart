part of 'support_bloc.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportLoading extends SupportState {}

class SupportLoaded extends SupportState {
  final List<SupportConversationEntity> conversations;
  final List<SupportConversationEntity> filteredConversations;
  final String? selectedConversationId;

  const SupportLoaded({
    required this.conversations,
    required this.filteredConversations,
    required this.selectedConversationId,
  });

  SupportConversationEntity? get selectedConversation {
    if (selectedConversationId == null) {
      return null;
    }
    for (final conversation in conversations) {
      if (conversation.id == selectedConversationId) {
        return conversation;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
    conversations,
    filteredConversations,
    selectedConversationId,
  ];
}

class SupportError extends SupportState {
  final String message;

  const SupportError(this.message);

  @override
  List<Object?> get props => [message];
}
