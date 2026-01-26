import 'package:equatable/equatable.dart';

/// User Form Events for BLoC
abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize form with optional user data for edit mode
class InitializeFormEvent extends UserFormEvent {
  final bool isEditMode;
  final String userType; // Master or Client
  final Map<String, dynamic>? userData;

  const InitializeFormEvent({
    required this.isEditMode,
    required this.userType,
    this.userData,
  });

  @override
  List<Object?> get props => [isEditMode, userType, userData];
}

/// Navigate to next or previous step
class UpdateStepEvent extends UserFormEvent {
  final int step;

  const UpdateStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

/// Go to next step
class NextStepEvent extends UserFormEvent {
  const NextStepEvent();
}

/// Go to previous step
class PreviousStepEvent extends UserFormEvent {
  const PreviousStepEvent();
}

/// Update a single form field
class UpdateFormFieldEvent extends UserFormEvent {
  final String fieldName;
  final dynamic value;

  const UpdateFormFieldEvent({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

/// Update exchange selection (toggle on/off)
class UpdateExchangeSelectionEvent extends UserFormEvent {
  final String exchange;
  final bool isSelected;

  const UpdateExchangeSelectionEvent({
    required this.exchange,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [exchange, isSelected];
}

/// Toggle all exchanges
class ToggleAllExchangesEvent extends UserFormEvent {
  final bool selectAll;

  const ToggleAllExchangesEvent(this.selectAll);

  @override
  List<Object?> get props => [selectAll];
}

/// Update exchange group assignment
/// Supports both single group (String) and multiple groups (List<String>)
class UpdateExchangeGroupEvent extends UserFormEvent {
  final String exchange;
  final dynamic group; // Can be String? or List<String>

  const UpdateExchangeGroupEvent({
    required this.exchange,
    required this.group,
  });

  @override
  List<Object?> get props => [exchange, group];
}

/// Update high/low trade limit selection
class UpdateTradeLimitEvent extends UserFormEvent {
  final String exchange;
  final bool isSelected;

  const UpdateTradeLimitEvent({
    required this.exchange,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [exchange, isSelected];
}

/// Toggle all trade limits
class ToggleAllTradeLimitsEvent extends UserFormEvent {
  final bool selectAll;

  const ToggleAllTradeLimitsEvent(this.selectAll);

  @override
  List<Object?> get props => [selectAll];
}

/// Update trigger setting (toggle on/off)
class UpdateTriggerSettingEvent extends UserFormEvent {
  final String settingName;
  final bool isEnabled;

  const UpdateTriggerSettingEvent({
    required this.settingName,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [settingName, isEnabled];
}

/// Update exchange setting (dropdown, toggle, radio)
class UpdateExchangeSettingEvent extends UserFormEvent {
  final String settingName;
  final dynamic value;

  const UpdateExchangeSettingEvent({
    required this.settingName,
    required this.value,
  });

  @override
  List<Object?> get props => [settingName, value];
}

/// Update brokerage table data
class UpdateBrokerageEvent extends UserFormEvent {
  final String exchange;
  final bool isSelected;
  final String? turnoverWise;
  final String? symbolWiseBrk;

  const UpdateBrokerageEvent({
    required this.exchange,
    required this.isSelected,
    this.turnoverWise,
    this.symbolWiseBrk,
  });

  @override
  List<Object?> get props => [
    exchange,
    isSelected,
    turnoverWise,
    symbolWiseBrk,
  ];
}

/// Update brokerage view mode (Exchange Wise / Symbol Wise)
class UpdateBrokerageViewModeEvent extends UserFormEvent {
  final String mode;

  const UpdateBrokerageViewModeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

class SubmitFormEvent extends UserFormEvent {
  const SubmitFormEvent();
}

class ResetFormEvent extends UserFormEvent {
  const ResetFormEvent();
}

class ToggleAllBrokerageExchangesEvent extends UserFormEvent {
  final bool selectAll;

  const ToggleAllBrokerageExchangesEvent(this.selectAll);

  @override
  List<Object?> get props => [selectAll];
}