import 'package:equatable/equatable.dart';

abstract class BillGenerateEvent extends Equatable {
  const BillGenerateEvent();
  @override
  List<Object?> get props => [];
}

class LoadBillGenerateReport extends BillGenerateEvent {
  final String? userId;
  final String? billFormat;
  final String? billType;
  const LoadBillGenerateReport({this.userId, this.billFormat, this.billType});
  @override
  List<Object?> get props => [userId, billFormat, billType];
}

class FilterBillGenerateReport extends BillGenerateEvent {
  final String? userId;
  final String? billFormat;
  final String? billType;
  const FilterBillGenerateReport({this.userId, this.billFormat, this.billType});
  @override
  List<Object?> get props => [userId, billFormat, billType];
}
