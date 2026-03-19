import 'package:equatable/equatable.dart';

class BillComparisonEntity extends Equatable {
  final int index;
  final String username;
  final String billTotal;
  final String billBrokerage;
  final String billNetTotal;
  final String settlementTotal;
  final String settlementBrokerage;
  final String settlementNetTotal;
  final String type;
  const BillComparisonEntity({
    required this.index,
    required this.username,
    required this.billTotal,
    required this.billBrokerage,
    required this.billNetTotal,
    required this.settlementTotal,
    required this.settlementBrokerage,
    required this.settlementNetTotal,
    required this.type,
  });
  bool get isTotalMismatch => billTotal != settlementTotal;
  bool get isBrokerageMismatch => billBrokerage != settlementBrokerage;
  bool get isNetTotalMismatch => billNetTotal != settlementNetTotal;
  @override
  List<Object?> get props => [
    index,
    username,
    billTotal,
    billBrokerage,
    billNetTotal,
    settlementTotal,
    settlementBrokerage,
    settlementNetTotal,
    type,
  ];
}