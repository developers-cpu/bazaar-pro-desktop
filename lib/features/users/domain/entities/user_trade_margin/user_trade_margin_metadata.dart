import 'package:equatable/equatable.dart';

class UserTradeMarginMetadata extends Equatable {
  final List<String> exchanges;
  final List<String> symbols;
  const UserTradeMarginMetadata({
    required this.exchanges,
    required this.symbols,
  });
  @override
  List<Object> get props => [exchanges, symbols];
}
