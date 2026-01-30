import 'package:equatable/equatable.dart';

abstract class UserBrokerageEvent extends Equatable {
  const UserBrokerageEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserBrokerage extends UserBrokerageEvent {
  final String userId;
  const LoadUserBrokerage(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleBrokerageType extends UserBrokerageEvent {
  final String viewType; // 'Exchange' or 'Symbol'
  const ToggleBrokerageType(this.viewType);

  @override
  List<Object?> get props => [viewType];
}

class FilterBrokerage extends UserBrokerageEvent {
  final String? exchange;
  final String? symbol; // For symbol wise filtering if needed

  const FilterBrokerage({this.exchange, this.symbol});

  @override
  List<Object?> get props => [exchange, symbol];
}

class UpdateBrokerageSettings extends UserBrokerageEvent {
  final List<String> selectedIds;
  final double? turnoverWiseBrk;
  final double?
  symbolWiseBrk; // Used for both modes (in Symbol mode only this is used)

  const UpdateBrokerageSettings({
    required this.selectedIds,
    this.turnoverWiseBrk,
    this.symbolWiseBrk,
  });

  @override
  List<Object?> get props => [selectedIds, turnoverWiseBrk, symbolWiseBrk];
}
