import 'package:equatable/equatable.dart';
import '../../../domain/entities/broker_list/broker.dart';
import '../../../domain/entities/broker_list/broker_client.dart';
abstract class BrokerListState extends Equatable {
  const BrokerListState();
  @override
  List<Object?> get props => [];
}
class BrokerListInitial extends BrokerListState {}
class BrokerListLoading extends BrokerListState {}
class BrokerListLoaded extends BrokerListState {
  final List<Broker> brokers;
  const BrokerListLoaded({required this.brokers});
  @override
  List<Object?> get props => [brokers];
}
class BrokerClientsLoaded extends BrokerListState {
  final List<Broker> brokers;
  final List<BrokerClient> clients;
  const BrokerClientsLoaded({required this.brokers, required this.clients});
  @override
  List<Object?> get props => [brokers, clients];
}
class BrokerListError extends BrokerListState {
  final String message;
  const BrokerListError({required this.message});
  @override
  List<Object?> get props => [message];
}
