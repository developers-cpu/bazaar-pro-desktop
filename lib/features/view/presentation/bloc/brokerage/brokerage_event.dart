import 'package:equatable/equatable.dart';

abstract class BrokerageEvent extends Equatable {
  const BrokerageEvent();
  @override
  List<Object?> get props => [];
}

class LoadBrokeragesEvent extends BrokerageEvent {
  final String? exchange;
  const LoadBrokeragesEvent({this.exchange});
  @override
  List<Object?> get props => [exchange];
}

class ResetBrokerageEvent extends BrokerageEvent {
  const ResetBrokerageEvent();
}
