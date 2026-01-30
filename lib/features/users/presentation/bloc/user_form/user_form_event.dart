import 'package:equatable/equatable.dart';


abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object?> get props => [];
}


class InitializeFormEvent extends UserFormEvent {
  final bool isEditMode;
  final String userType; 
  final Map<String, dynamic>? userData;

  const InitializeFormEvent({
    required this.isEditMode,
    required this.userType,
    this.userData,
  });

  @override
  List<Object?> get props => [isEditMode, userType, userData];
}


class UpdateStepEvent extends UserFormEvent {
  final int step;

  const UpdateStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}


class NextStepEvent extends UserFormEvent {
  const NextStepEvent();
}


class PreviousStepEvent extends UserFormEvent {
  const PreviousStepEvent();
}


class UpdateFormFieldEvent extends UserFormEvent {
  final String fieldName;
  final dynamic value;

  const UpdateFormFieldEvent({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}


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


class ToggleAllExchangesEvent extends UserFormEvent {
  final bool selectAll;

  const ToggleAllExchangesEvent(this.selectAll);

  @override
  List<Object?> get props => [selectAll];
}



class UpdateExchangeGroupEvent extends UserFormEvent {
  final String exchange;
  final dynamic group; 

  const UpdateExchangeGroupEvent({
    required this.exchange,
    required this.group,
  });

  @override
  List<Object?> get props => [exchange, group];
}


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


class ToggleAllTradeLimitsEvent extends UserFormEvent {
  final bool selectAll;

  const ToggleAllTradeLimitsEvent(this.selectAll);

  @override
  List<Object?> get props => [selectAll];
}


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