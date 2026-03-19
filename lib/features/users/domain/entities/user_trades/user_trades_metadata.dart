import 'package:equatable/equatable.dart';

class UserTradesMetadata extends Equatable {
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> statuses;
  const UserTradesMetadata({
    required this.exchanges,
    required this.symbols,
    required this.statuses,
  });
  @override
  List<Object> get props => [exchanges, symbols, statuses];
}