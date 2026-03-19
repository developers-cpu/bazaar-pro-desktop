import 'package:equatable/equatable.dart';

class Broker extends Equatable {
  final int index;
  final DateTime createdAt;
  final String name;
  final int clientsCount;
  final double totalBrokerage;
  final DateTime updatedOn;
  const Broker({
    required this.index,
    required this.createdAt,
    required this.name,
    required this.clientsCount,
    required this.totalBrokerage,
    required this.updatedOn,
  });
  @override
  List<Object?> get props => [
    index,
    createdAt,
    name,
    clientsCount,
    totalBrokerage,
    updatedOn,
  ];
}