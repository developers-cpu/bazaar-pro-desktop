import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/broker_list/broker.dart';
import '../../../domain/repositories/broker_list/broker_repository.dart';
import 'broker_list_event.dart';
import 'broker_list_state.dart';
class BrokerListBloc extends Bloc<BrokerListEvent, BrokerListState> {
  final BrokerRepository repository;
  BrokerListBloc({required this.repository}) : super(BrokerListInitial()) {
    on<LoadBrokersEvent>(_onLoadBrokers);
    on<LoadBrokerClientsEvent>(_onLoadBrokerClients);
  }
  Future<void> _onLoadBrokers(
    LoadBrokersEvent event,
    Emitter<BrokerListState> emit,
  ) async {
    emit(BrokerListLoading());
    try {
      final brokers = await repository.getBrokers();
      emit(BrokerListLoaded(brokers: brokers));
    } catch (e) {
      emit(BrokerListError(message: e.toString()));
    }
  }
  Future<void> _onLoadBrokerClients(
    LoadBrokerClientsEvent event,
    Emitter<BrokerListState> emit,
  ) async {
    try {
      final currentBrokers = _getCurrentBrokers();
      final clients = await repository.getBrokerClients(event.brokerName);
      emit(BrokerClientsLoaded(brokers: currentBrokers, clients: clients));
    } catch (e) {
      emit(BrokerListError(message: e.toString()));
    }
  }
  List<Broker> _getCurrentBrokers() {
    final s = state;
    if (s is BrokerListLoaded) return s.brokers;
    if (s is BrokerClientsLoaded) return s.brokers;
    return [];
  }
}
