import 'package:equatable/equatable.dart';

abstract class BrokerListEvent extends Equatable {
  const BrokerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrokersEvent extends BrokerListEvent {
  const LoadBrokersEvent();
}

class LoadBrokerClientsEvent extends BrokerListEvent {
  final String brokerName;

  const LoadBrokerClientsEvent({required this.brokerName});

  @override
  List<Object?> get props => [brokerName];
}
