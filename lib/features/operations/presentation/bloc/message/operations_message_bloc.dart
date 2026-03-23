import 'package:flutter_bloc/flutter_bloc.dart';
import 'operations_message_event.dart';
import 'operations_message_state.dart';

class OperationsMessageBloc
    extends Bloc<OperationsMessageEvent, OperationsMessageState> {
  OperationsMessageBloc() : super(const OperationsMessageState()) {
    on<ChangeMessageTabEvent>(_onChangeTab);
    on<ChangeRollTypeEvent>(_onChangeRollType);
    on<UpdateMessageEvent>(_onUpdateMessage);
  }
  void _onChangeTab(
    ChangeMessageTabEvent event,
    Emitter<OperationsMessageState> emit,
  ) {
    emit(
      state.copyWith(
        activeTab: event.index,
        status: OperationsMessageStatus.initial,
      ),
    );
  }

  void _onChangeRollType(
    ChangeRollTypeEvent event,
    Emitter<OperationsMessageState> emit,
  ) {
    emit(
      state.copyWith(
        rollType: event.rollType,
        status: OperationsMessageStatus.initial,
      ),
    );
  }

  Future<void> _onUpdateMessage(
    UpdateMessageEvent event,
    Emitter<OperationsMessageState> emit,
  ) async {
    emit(state.copyWith(status: OperationsMessageStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        state.copyWith(
          status: OperationsMessageStatus.success,
          message: 'Message updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OperationsMessageStatus.failure,
          message: 'Failed to update message: $e',
        ),
      );
    }
  }
}
