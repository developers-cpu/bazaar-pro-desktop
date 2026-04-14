import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_form_event.dart';
import 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  UserFormBloc() : super(const UserFormState()) {
    on<InitializeFormEvent>(_onInitializeForm);
    on<LoadFormDataEvent>(_onLoadFormData);
    on<UpdateStepEvent>(_onUpdateStep);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<UpdateFormFieldEvent>(_onUpdateFormField);
    on<UpdateExchangeSelectionEvent>(_onUpdateExchangeSelection);
    on<ToggleAllExchangesEvent>(_onToggleAllExchanges);
    on<UpdateExchangeGroupEvent>(_onUpdateExchangeGroup);
    on<UpdateTradeLimitEvent>(_onUpdateTradeLimit);
    on<ToggleAllTradeLimitsEvent>(_onToggleAllTradeLimits);
    on<UpdateTriggerSettingEvent>(_onUpdateTriggerSetting);
    on<UpdateExchangeSettingEvent>(_onUpdateExchangeSetting);
    on<UpdateExchangeTableSettingEvent>(_onUpdateExchangeTableSetting);
    on<UpdateBrokerageEvent>(_onUpdateBrokerage);
    on<ToggleAllBrokerageExchangesEvent>(_onToggleAllBrokerageExchanges);
    on<UpdateBrokerageViewModeEvent>(_onUpdateBrokerageViewMode);
    on<SubmitFormEvent>(_onSubmitForm);
    on<ResetFormEvent>(_onResetForm);
    on<UpdateSpreadFileEvent>(_onUpdateSpreadFile);
  }
  Future<void> _onLoadFormData(
    LoadFormDataEvent event,
    Emitter<UserFormState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final leverageOptions = [
      '1:1',
      '1:2',
      '1:5',
      '1:10',
      '1:50',
      '1:100',
      '1:500',
    ];
    final exchangeGroupOptions = [
      'NSE_X',
      'NSE_2X',
      'NSE_3X',
      'NSE_4X',
      'NSE_5X',
    ];
    emit(
      state.copyWith(
        leverageOptions: leverageOptions,
        exchangeGroupOptions: exchangeGroupOptions,
      ),
    );
  }

  void _onInitializeForm(
    InitializeFormEvent event,
    Emitter<UserFormState> emit,
  ) {
    if (event.isEditMode && event.userData != null) {
      final userData = event.userData!;
      emit(
        state.copyWith(
          isEditMode: true,
          userType: event.userType,
          currentStep: 0,
          name: userData['name'] as String? ?? '',
          username: userData['username'] as String? ?? '',
          mobile: userData['mobile'] as String? ?? '',
          credit: userData['credit'] as String? ?? '',
          leverage: userData['leverage'] as String?,
          creditLimit: userData['creditLimit'] as String? ?? '',
          remark: userData['remark'] as String? ?? '',
          allowedDevice: userData['allowedDevice'] as String? ?? '',
          plSharing: userData['plSharing'] as String? ?? '',
          brokerageSharing: userData['brokerageSharing'] as String? ?? '',
          triggerSettings: UserFormState.defaultTriggerSettings,
          brokerageData: UserFormState.defaultBrokerageData,
        ),
      );
    } else {
      emit(
        UserFormState(
          isEditMode: false,
          userType: event.userType,
          currentStep: 0,
          triggerSettings: UserFormState.defaultTriggerSettings,
          brokerageData: UserFormState.defaultBrokerageData,
        ),
      );
    }
    add(const LoadFormDataEvent());
  }

  void _onUpdateStep(UpdateStepEvent event, Emitter<UserFormState> emit) {
    if (event.step >= 0 && event.step < state.totalSteps) {
      emit(state.copyWith(currentStep: event.step));
    }
  }

  void _onNextStep(NextStepEvent event, Emitter<UserFormState> emit) {
    if (!state.isLastStep) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<UserFormState> emit) {
    if (!state.isFirstStep) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateFormField(
    UpdateFormFieldEvent event,
    Emitter<UserFormState> emit,
  ) {
    switch (event.fieldName) {
      case 'name':
        emit(state.copyWith(name: event.value as String));
        break;
      case 'username':
        emit(state.copyWith(username: event.value as String));
        break;
      case 'password':
        emit(state.copyWith(password: event.value as String));
        break;
      case 'confirmPassword':
        emit(state.copyWith(confirmPassword: event.value as String));
        break;
      case 'mobile':
        emit(state.copyWith(mobile: event.value as String));
        break;
      case 'credit':
        emit(state.copyWith(credit: event.value as String));
        break;
      case 'leverage':
        emit(state.copyWith(leverage: event.value as String?));
        break;
      case 'creditLimit':
        emit(state.copyWith(creditLimit: event.value as String));
        break;
      case 'remark':
        emit(state.copyWith(remark: event.value as String));
        break;
      case 'allowedDevice':
        emit(state.copyWith(allowedDevice: event.value as String));
        break;
      case 'cutOff':
        emit(state.copyWith(cutOff: event.value as String));
        break;
      case 'selectedMaster':
        emit(state.copyWith(selectedMaster: event.value as String?));
        break;
      case 'selectedServer':
        emit(state.copyWith(selectedServer: event.value as String?));
        break;
      case 'plSharing':
        emit(state.copyWith(plSharing: event.value as String));
        break;
      case 'brokerageSharing':
        emit(state.copyWith(brokerageSharing: event.value as String));
        break;
      case 'squareOffTiming':
        emit(state.copyWith(squareOffTiming: event.value as String));
        break;
      case 'specificTime':
        emit(state.copyWith(specificTime: event.value as String));
        break;
      case 'exchangeWiseBrk':
        emit(state.copyWith(exchangeWiseBrk: event.value as String));
        break;
      case 'symbolWiseBrk':
        emit(state.copyWith(symbolWiseBrk: event.value as String));
        break;
    }
  }

  void _onUpdateExchangeSelection(
    UpdateExchangeSelectionEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedExchanges);
    if (event.isSelected) {
      newSelection.add(event.exchange);
    } else {
      newSelection.remove(event.exchange);
    }
    emit(state.copyWith(selectedExchanges: newSelection));
  }

  void _onToggleAllExchanges(
    ToggleAllExchangesEvent event,
    Emitter<UserFormState> emit,
  ) {
    if (event.selectAll) {
      emit(
        state.copyWith(
          selectedExchanges: Set.from(UserFormState.availableExchanges),
        ),
      );
    } else {
      emit(state.copyWith(selectedExchanges: {}));
    }
  }

  void _onUpdateExchangeGroup(
    UpdateExchangeGroupEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newGroups = Map<String, String?>.from(state.exchangeGroups);
    newGroups[event.exchange] = event.group;
    emit(state.copyWith(exchangeGroups: newGroups));
  }

  void _onUpdateTradeLimit(
    UpdateTradeLimitEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedTradeLimits);
    if (event.isSelected) {
      newSelection.add(event.exchange);
    } else {
      newSelection.remove(event.exchange);
    }
    emit(state.copyWith(selectedTradeLimits: newSelection));
  }

  void _onToggleAllTradeLimits(
    ToggleAllTradeLimitsEvent event,
    Emitter<UserFormState> emit,
  ) {
    if (event.selectAll) {
      emit(
        state.copyWith(
          selectedTradeLimits: Set.from(UserFormState.availableExchanges),
        ),
      );
    } else {
      emit(state.copyWith(selectedTradeLimits: {}));
    }
  }

  void _onUpdateTriggerSetting(
    UpdateTriggerSettingEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newSettings = Map<String, bool>.from(state.triggerSettings);
    newSettings[event.settingName] = event.isEnabled;
    emit(state.copyWith(triggerSettings: newSettings));
  }

  void _onUpdateExchangeSetting(
    UpdateExchangeSettingEvent event,
    Emitter<UserFormState> emit,
  ) {
    switch (event.settingName) {
      case 'selectedExchange':
        emit(state.copyWith(selectedExchangeSetting: event.value as String?));
        break;
      case 'allowSquareOff':
        emit(state.copyWith(allowSquareOff: event.value as bool));
        break;
      case 'marketOpenTimeRestriction':
        emit(state.copyWith(marketOpenTimeRestriction: event.value as String));
        break;
    }
  }

  void _onUpdateExchangeTableSetting(
    UpdateExchangeTableSettingEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newData = Map<String, Map<String, String>>.from(
      state.exchangeSettingTableData,
    );
    final existingRow = Map<String, String>.from(
      newData[event.exchange] ?? {'profitSquareOff': '', 'timeRestriction': ''},
    );
    existingRow[event.field] = event.value;
    newData[event.exchange] = existingRow;
    emit(state.copyWith(exchangeSettingTableData: newData));
  }

  void _onUpdateBrokerage(
    UpdateBrokerageEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedBrokerageExchanges);
    if (event.isSelected) {
      newSelection.add(event.exchange);
    } else {
      newSelection.remove(event.exchange);
    }
    final newBrokerageData = Map<String, BrokerageData>.from(
      state.brokerageData,
    );
    if (event.turnoverWise != null || event.symbolWiseBrk != null) {
      final existing =
          state.brokerageData[event.exchange] ??
          BrokerageData(
            exchange: event.exchange,
            turnoverWise: '0',
            symbolWiseBrk: '0',
          );
      newBrokerageData[event.exchange] = existing.copyWith(
        turnoverWise: event.turnoverWise,
        symbolWiseBrk: event.symbolWiseBrk,
      );
    }
    emit(
      state.copyWith(
        selectedBrokerageExchanges: newSelection,
        brokerageData: newBrokerageData,
      ),
    );
  }

  void _onToggleAllBrokerageExchanges(
    ToggleAllBrokerageExchangesEvent event,
    Emitter<UserFormState> emit,
  ) {
    if (event.selectAll) {
      emit(
        state.copyWith(
          selectedBrokerageExchanges: Set.from(
            UserFormState.availableExchanges,
          ),
        ),
      );
    } else {
      emit(state.copyWith(selectedBrokerageExchanges: {}));
    }
  }

  void _onUpdateBrokerageViewMode(
    UpdateBrokerageViewModeEvent event,
    Emitter<UserFormState> emit,
  ) {
    emit(state.copyWith(brokerageViewMode: event.mode));
  }
  void _onUpdateSpreadFile(
    UpdateSpreadFileEvent event,
    Emitter<UserFormState> emit,
  ) {
    final newFiles = Map<String, String>.from(state.spreadSettingFiles);
    if (event.filePath == null) {
      newFiles.remove(event.exchange);
    } else {
      newFiles[event.exchange] = event.filePath!;
    }
    emit(state.copyWith(spreadSettingFiles: newFiles));
  }

  Future<void> _onSubmitForm(
    SubmitFormEvent event,
    Emitter<UserFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<UserFormState> emit) {
    emit(const UserFormState());
  }
}
