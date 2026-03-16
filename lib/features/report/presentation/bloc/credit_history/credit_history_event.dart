import 'package:equatable/equatable.dart';
abstract class CreditHistoryEvent extends Equatable {
  const CreditHistoryEvent();
  @override
  List<Object?> get props => [];
}
class LoadCreditHistory extends CreditHistoryEvent {
  const LoadCreditHistory();
}
class FilterCreditHistory extends CreditHistoryEvent {
  final String? type;
  final String? user;
  const FilterCreditHistory({this.type, this.user});
  @override
  List<Object?> get props => [type, user];
}
class CreditHistoryFilter extends CreditHistoryEvent {
  final String? type;
  final String? user;
  const CreditHistoryFilter({this.type, this.user});
  @override
  List<Object?> get props => [type, user];
}
class ResetCreditHistoryFilters extends CreditHistoryEvent {
  const ResetCreditHistoryFilters();
}
