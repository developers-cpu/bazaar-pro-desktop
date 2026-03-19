import 'package:equatable/equatable.dart';

class BrokerClient extends Equatable {
  final String name;
  final double brokerage;
  const BrokerClient({required this.name, required this.brokerage});
  @override
  List<Object?> get props => [name, brokerage];
}