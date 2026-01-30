import 'package:equatable/equatable.dart';

abstract class UserQuantitySettingsEvent extends Equatable {
  const UserQuantitySettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserQuantitySettings extends UserQuantitySettingsEvent {
  final String userId;

  const LoadUserQuantitySettings(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FilterUserQuantitySettings extends UserQuantitySettingsEvent {
  final String? symbol;

  const FilterUserQuantitySettings({this.symbol});

  @override
  List<Object?> get props => [symbol];
}

class UpdateUserQuantitySetting extends UserQuantitySettingsEvent {
  final String settingId;
  final int? maxQty;
  final int? breakupQty;
  final int? maxLot;
  final int? breakupLot;

  const UpdateUserQuantitySetting({
    required this.settingId,
    this.maxQty,
    this.breakupQty,
    this.maxLot,
    this.breakupLot,
  });

  @override
  List<Object?> get props => [
    settingId,
    maxQty,
    breakupQty,
    maxLot,
    breakupLot,
  ];
}

class UpdateSelectedUserQuantitySetting extends UserQuantitySettingsEvent {
  final List<String> selectedIds;
  final int? maxQty;
  final int? breakupQty;
  final int? maxLot;
  final int? breakupLot;
  final String? symbol; 

  const UpdateSelectedUserQuantitySetting({
    required this.selectedIds,
    this.maxQty,
    this.breakupQty,
    this.maxLot,
    this.breakupLot,
    this.symbol,
  });

  @override
  List<Object?> get props => [
    selectedIds,
    maxQty,
    breakupQty,
    maxLot,
    breakupLot,
    symbol,
  ];
}
