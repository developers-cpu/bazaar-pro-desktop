import 'package:equatable/equatable.dart';
class UserRejectionLogMetadata extends Equatable {
  final List<String> exchanges;
  final List<String> symbols;
  const UserRejectionLogMetadata({
    required this.exchanges,
    required this.symbols,
  });
  @override
  List<Object> get props => [exchanges, symbols];
}
