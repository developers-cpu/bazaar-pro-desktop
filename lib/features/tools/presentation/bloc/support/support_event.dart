part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupportData extends SupportEvent {}

class SearchSupportConversations extends SupportEvent {
  final String query;

  const SearchSupportConversations(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectSupportConversation extends SupportEvent {
  final String conversationId;

  const SelectSupportConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class SendSupportMessage extends SupportEvent {
  final SupportMessageEntity message;

  const SendSupportMessage(this.message);

  @override
  List<Object?> get props => [message];
}
