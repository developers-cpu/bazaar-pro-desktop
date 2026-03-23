import 'package:equatable/equatable.dart';

abstract class BillComparisonEvent extends Equatable {
  const BillComparisonEvent();
  @override
  List<Object?> get props => [];
}

class LoadBillComparisonEvent extends BillComparisonEvent {
  final String startDate;
  final String endDate;
  const LoadBillComparisonEvent({
    required this.startDate,
    required this.endDate,
  });
  @override
  List<Object?> get props => [startDate, endDate];
}

class SearchBillComparisonEvent extends BillComparisonEvent {
  final String query;
  const SearchBillComparisonEvent(this.query);
  @override
  List<Object?> get props => [query];
}
