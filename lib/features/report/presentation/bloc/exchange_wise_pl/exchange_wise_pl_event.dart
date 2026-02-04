import 'package:equatable/equatable.dart';

abstract class ExchangeWisePLEvent extends Equatable {
  const ExchangeWisePLEvent();

  @override
  List<Object> get props => [];
}

class LoadExchangeWisePL extends ExchangeWisePLEvent {
  const LoadExchangeWisePL();
}
