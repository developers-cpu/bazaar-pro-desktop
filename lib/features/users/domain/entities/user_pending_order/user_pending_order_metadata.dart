import 'package:equatable/equatable.dart';

class UserPendingOrderMetadata extends Equatable {
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> orderTypes;
  const UserPendingOrderMetadata({
    required this.exchanges,
    required this.symbols,
    required this.orderTypes,
  });
  @override
  List<Object> get props => [exchanges, symbols, orderTypes];
}
