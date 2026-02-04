import 'package:equatable/equatable.dart';

abstract class UserWiseProfitAndLossEvent extends Equatable {
  const UserWiseProfitAndLossEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserWiseProfitAndLoss extends UserWiseProfitAndLossEvent {}

class FilterUserWiseProfitAndLoss extends UserWiseProfitAndLossEvent {
  final String? startDate;
  final String? endDate;
  final String? userId;

  const FilterUserWiseProfitAndLoss({
    this.startDate,
    this.endDate,
    this.userId,
  });

  @override
  List<Object?> get props => [startDate, endDate, userId];
}

class ResetUserWiseProfitAndLossFilters extends UserWiseProfitAndLossEvent {
  const ResetUserWiseProfitAndLossFilters();
}
