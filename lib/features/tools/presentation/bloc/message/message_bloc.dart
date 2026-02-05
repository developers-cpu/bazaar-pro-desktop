import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../../../core/usecases/usecase.dart';
part 'message_event.dart';
part 'message_state.dart';
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase getMessages;
  MessageBloc({required this.getMessages}) : super(MessageLoading()) {
    on<LoadMessages>(_onLoadMessages);
  }
  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    final result = await getMessages(NoParams());
    result.fold(
      (failure) => emit(const MessageError('Failed to load messages')),
      (messages) {
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        emit(MessageLoaded(messages));
      },
    );
  }
}
