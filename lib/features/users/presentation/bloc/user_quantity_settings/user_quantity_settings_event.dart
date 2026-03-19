import 'package:equatable/equatable.dart';

abstract class UserQuantitySettingsEvent extends Equatable {
  const UserQuantitySettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadUserQuantitySettings extends UserQuantitySettingsEvent {
  final String userId;
  const LoadUserQuantitySettings(this.userId);
  @override
  List<Object> get props => [userId];
}

class FilterUserQuantitySettings extends UserQuantitySettingsEvent {
  final String? symbol;
  const FilterUserQuantitySettings({this.symbol});
  @override
  List<Object> get props => [symbol ?? ''];
}

class UpdateSelectedUserQuantitySetting extends UserQuantitySettingsEvent {
  final List<String> selectedIds;
  final int? maxQty;
  final int? breakupQty;
  final int? maxLot;
  final int? breakupLot;
  const UpdateSelectedUserQuantitySetting({
    required this.selectedIds,
    this.maxQty,
    this.breakupQty,
    this.maxLot,
    this.breakupLot,
  });
  @override
  List<Object> get props => [
    selectedIds,
    maxQty ?? 0,
    breakupQty ?? 0,
    maxLot ?? 0,
    breakupLot ?? 0,
  ];
}