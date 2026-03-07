import 'package:equatable/equatable.dart';
import '../../../domain/entities/brokerage/brokerage.dart';

abstract class BrokerageState extends Equatable {
  const BrokerageState();
  @override
  List<Object?> get props => [];
}

class BrokerageInitial extends BrokerageState {}

class BrokerageFilterUpdated extends BrokerageState {
  final String selectedExchange;
  const BrokerageFilterUpdated(this.selectedExchange);
  @override
  List<Object?> get props => [selectedExchange];
}

class BrokerageLoading extends BrokerageState {}

class BrokerageLoaded extends BrokerageState {
  final List<Brokerage> brokerages;
  final String? selectedExchange;
  final List<String> exchanges;

  const BrokerageLoaded({
    required this.brokerages,
    this.selectedExchange,
    this.exchanges = const [
      'NSE',
      'MCX',
      'CE/PE',
      'OTHERS',
      'COMEX',
      'CRYPTO',
      'GIFT',
      'FOREX',
    ],
  });

  BrokerageLoaded copyWith({
    List<Brokerage>? brokerages,
    String? selectedExchange,
  }) {
    return BrokerageLoaded(
      brokerages: brokerages ?? this.brokerages,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      exchanges: exchanges,
    );
  }

  @override
  List<Object?> get props => [brokerages, selectedExchange, exchanges];
}

class BrokerageError extends BrokerageState {
  final String message;
  const BrokerageError({required this.message});
  @override
  List<Object?> get props => [message];
}
