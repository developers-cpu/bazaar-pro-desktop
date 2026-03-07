import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/brokerage/brokerage_repository.dart';
import 'brokerage_event.dart';
import 'brokerage_state.dart';

class BrokerageBloc extends Bloc<BrokerageEvent, BrokerageState> {
  final BrokerageRepository repository;

  BrokerageBloc({required this.repository}) : super(BrokerageInitial()) {
    on<LoadBrokeragesEvent>(_onLoadBrokerages);
    on<UpdateBrokerageFilterEvent>(
      (event, emit) => emit(BrokerageFilterUpdated(event.exchange)),
    );
    on<RestoreBrokerageFilterEvent>(
      (event, emit) => emit(BrokerageFilterUpdated(event.exchange)),
    );
    on<ResetBrokerageEvent>((event, emit) => emit(BrokerageInitial()));
  }

  Future<void> _onLoadBrokerages(
    LoadBrokeragesEvent event,
    Emitter<BrokerageState> emit,
  ) async {
    emit(BrokerageLoading());
    try {
      final brokerages = await repository.getBrokerages(
        exchange: event.exchange,
      );
      emit(
        BrokerageLoaded(
          brokerages: brokerages,
          selectedExchange: event.exchange,
        ),
      );
    } catch (e) {
      emit(BrokerageError(message: e.toString()));
    }
  }
}
