import 'package:equatable/equatable.dart';

class UserFormState extends Equatable {
  final bool isEditMode;
  final String userType;
  final Map<String, dynamic>? userData;
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;
  final String name;
  final String username;
  final String password;
  final String confirmPassword;
  final String mobile;
  final String credit;
  final String? leverage;
  final String creditLimit;
  final String remark;
  final String allowedDevice;
  final String cutOff;
  final Set<String> selectedExchanges;
  final Map<String, String?> exchangeGroups;
  final String plSharing;
  final String brokerageSharing;
  final String? selectedExchangeSetting;
  final bool allowSquareOff;
  final String squareOffTiming;
  final String marketOpenTimeRestriction;
  final String specificTime;
  final Set<String> selectedTradeLimits;
  final Map<String, bool> triggerSettings;
  final String brokerageViewMode;
  final String? selectedBrokerageExchange;
  final String exchangeWiseBrk;
  final String symbolWiseBrk;
  final Set<String> selectedBrokerageExchanges;
  final Map<String, BrokerageData> brokerageData;
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;
  final List<String> leverageOptions;
  final List<String> exchangeGroupOptions;
  final String? selectedMaster;
  final List<String> masterOptions;
  const UserFormState({
    this.isEditMode = false,
    this.userType = 'Master',
    this.userData,
    this.currentStep = 0,
    this.totalSteps = 7,
    this.stepTitles = const [
      'Personal Details',
      'Exchange Allow',
      'Profit & Loss Sharing Details',
      'Exchange Setting',
      'High Low Between Trade Limit',
      'Triggers Setting',
      'Brokerage Setting',
    ],
    this.name = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.mobile = '',
    this.credit = '',
    this.leverage,
    this.creditLimit = '',
    this.remark = '',
    this.allowedDevice = '',
    this.cutOff = '',
    this.selectedExchanges = const {},
    this.exchangeGroups = const {},
    this.plSharing = '',
    this.brokerageSharing = '',
    this.selectedExchangeSetting,
    this.allowSquareOff = false,
    this.squareOffTiming = '',
    this.marketOpenTimeRestriction = 'No Restriction',
    this.specificTime = '',
    this.selectedTradeLimits = const {},
    this.triggerSettings = const {},
    this.brokerageViewMode = 'Exchange Wise',
    this.selectedBrokerageExchange,
    this.exchangeWiseBrk = '',
    this.symbolWiseBrk = '',
    this.selectedBrokerageExchanges = const {},
    this.brokerageData = const {},
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
    this.leverageOptions = const [],
    this.exchangeGroupOptions = const [],
    this.selectedMaster,
    this.masterOptions = const [
      'Master 1',
      'Master 2',
      'Master 3',
      'Master 4',
      'Master 5',
    ],
  });
  static const List<String> availableExchanges = [
    'MCX',
    'NSE',
    'CE/PE',
    'OTHERS',
    'COMEX',
    'CRYPTO',
    'GIFTNIFTY',
    'USSTOCK',
    'FOREX',
  ];
  static const List<String> masterStepTitles = [
    'Personal Details',
    'Profit & Loss Sharing Details',
    'Exchange Allow',
    'Exchange Setting',
    'High Low Between Trade Limit',
    'Triggers Setting',
    'Brokerage Setting',
  ];
  static const List<String> clientStepTitles = [
    'Personal Details',
    'Exchange Allow',
    'High Low Between Trade Limit',
    'Trigger Settings',
    'Brokerage Settings',
    'Broker Settings',
  ];
  static const List<String> mastersClientStepTitles = [
    'Personal Details',
    'Exchange Allow',
    'High Low Between Trade Limit',
    'Trigger Settings',
    'Brokerage Settings',
  ];
  static const List<String> adminStepTitles = [
    'Personal Details',
    'Triggers Setting',
  ];
  static const List<TriggerSetting> masterTriggerSettings = [
    TriggerSetting(
      key: 'fifteenDays',
      label: 'Fifteen Days',
      icon: 'fifteen_days',
    ),
    TriggerSetting(
      key: 'freshLimitSL',
      label: 'Fresh Limit SL',
      icon: 'fresh_limit',
    ),
    TriggerSetting(
      key: 'autoSquareOff',
      label: 'Auto Square Off',
      icon: 'auto_square_off',
    ),
    TriggerSetting(
      key: 'symbolWiseSLLimit',
      label: 'Symbol wise SL/Limit (%)',
      icon: 'symbol_wise',
    ),
    TriggerSetting(
      key: 'changePasswordFirstTime',
      label: 'Change Password at first time',
      icon: 'change_password',
    ),
  ];
  static const List<TriggerSetting> clientTriggerSettings = [
    TriggerSetting(
      key: 'fifteenDays',
      label: 'Fifteen Days',
      icon: 'fifteen_days',
    ),
    TriggerSetting(
      key: 'freshLimitSL',
      label: 'Fresh Limit SL',
      icon: 'fresh_limit',
    ),
    TriggerSetting(
      key: 'autoSquareOff',
      label: 'Auto Square Off',
      icon: 'auto_square_off',
    ),
    TriggerSetting(
      key: 'symbolWiseSLLimit',
      label: 'Symbol wise SL/Limit (%)',
      icon: 'symbol_wise',
    ),
    TriggerSetting(
      key: 'changePasswordFirstTime',
      label: 'Change Password at first time',
      icon: 'change_password',
    ),
  ];
  static const List<TriggerSetting> adminTriggerSettings = [
    TriggerSetting(key: 'cmpOrder', label: 'CMP Order', icon: 'cmp_order'),
    TriggerSetting(
      key: 'deleteTrade',
      label: 'Delete Trade',
      icon: 'delete_trade',
    ),
    TriggerSetting(
      key: 'executePendingOrder',
      label: 'Execute Pending Order',
      icon: 'execute_pending_order',
    ),
    TriggerSetting(key: 'viewOnly', label: 'View Only', icon: 'view_only'),
    TriggerSetting(
      key: 'cancelOrder',
      label: 'Cancel Order',
      icon: 'cancel_order',
    ),
    TriggerSetting(key: 'showPL', label: 'Show P/L', icon: 'show_pl'),
    TriggerSetting(
      key: 'canDoSettlement',
      label: 'Can Do Settlement',
      icon: 'can_do_settlement',
    ),
  ];
  static List<TriggerSetting> getTriggerSettings(String userType) {
    if (userType == 'Admin') return adminTriggerSettings;
    return userType == 'Master' ? masterTriggerSettings : clientTriggerSettings;
  }

  static List<String> getStepTitles(String userType) {
    if (userType == 'Master') return masterStepTitles;
    if (userType == "Master's Client") return mastersClientStepTitles;
    if (userType == 'Admin') return adminStepTitles;
    return clientStepTitles;
  }

  static int getTotalSteps(String userType) {
    if (userType == 'Master') return 7;
    if (userType == 'Admin') return 2;
    return 5;
  }

  static const List<TriggerSetting> availableTriggerSettings =
      masterTriggerSettings;
  static Map<String, bool> get defaultTriggerSettings => {
    for (var setting in masterTriggerSettings) setting.key: false,
    for (var setting in adminTriggerSettings) setting.key: false,
  };
  static Map<String, BrokerageData> get defaultBrokerageData => {
    for (var exchange in availableExchanges)
      exchange: BrokerageData(
        exchange: exchange,
        turnoverWise: '0',
        symbolWiseBrk: '0',
      ),
  };
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == totalSteps - 1;
  String get currentStepTitle => stepTitles[currentStep];
  UserFormState copyWith({
    bool? isEditMode,
    String? userType,
    Map<String, dynamic>? userData,
    int? currentStep,
    int? totalSteps,
    List<String>? stepTitles,
    String? name,
    String? username,
    String? password,
    String? confirmPassword,
    String? mobile,
    String? credit,
    String? leverage,
    String? creditLimit,
    String? remark,
    String? allowedDevice,
    String? cutOff,
    Set<String>? selectedExchanges,
    Map<String, String?>? exchangeGroups,
    String? plSharing,
    String? brokerageSharing,
    String? selectedExchangeSetting,
    bool? allowSquareOff,
    String? squareOffTiming,
    String? marketOpenTimeRestriction,
    String? specificTime,
    Set<String>? selectedTradeLimits,
    Map<String, bool>? triggerSettings,
    String? brokerageViewMode,
    String? selectedBrokerageExchange,
    String? exchangeWiseBrk,
    String? symbolWiseBrk,
    Set<String>? selectedBrokerageExchanges,
    Map<String, BrokerageData>? brokerageData,
    bool? isSubmitting,
    String? error,
    bool? isSuccess,
    List<String>? leverageOptions,
    List<String>? exchangeGroupOptions,
    String? selectedMaster,
    List<String>? masterOptions,
  }) {
    return UserFormState(
      isEditMode: isEditMode ?? this.isEditMode,
      userType: userType ?? this.userType,
      userData: userData ?? this.userData,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      stepTitles: stepTitles ?? this.stepTitles,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      mobile: mobile ?? this.mobile,
      credit: credit ?? this.credit,
      leverage: leverage ?? this.leverage,
      creditLimit: creditLimit ?? this.creditLimit,
      remark: remark ?? this.remark,
      allowedDevice: allowedDevice ?? this.allowedDevice,
      cutOff: cutOff ?? this.cutOff,
      selectedExchanges: selectedExchanges ?? this.selectedExchanges,
      exchangeGroups: exchangeGroups ?? this.exchangeGroups,
      plSharing: plSharing ?? this.plSharing,
      brokerageSharing: brokerageSharing ?? this.brokerageSharing,
      selectedExchangeSetting:
          selectedExchangeSetting ?? this.selectedExchangeSetting,
      allowSquareOff: allowSquareOff ?? this.allowSquareOff,
      squareOffTiming: squareOffTiming ?? this.squareOffTiming,
      marketOpenTimeRestriction:
          marketOpenTimeRestriction ?? this.marketOpenTimeRestriction,
      specificTime: specificTime ?? this.specificTime,
      selectedTradeLimits: selectedTradeLimits ?? this.selectedTradeLimits,
      triggerSettings: triggerSettings ?? this.triggerSettings,
      brokerageViewMode: brokerageViewMode ?? this.brokerageViewMode,
      selectedBrokerageExchange:
          selectedBrokerageExchange ?? this.selectedBrokerageExchange,
      exchangeWiseBrk: exchangeWiseBrk ?? this.exchangeWiseBrk,
      symbolWiseBrk: symbolWiseBrk ?? this.symbolWiseBrk,
      selectedBrokerageExchanges:
          selectedBrokerageExchanges ?? this.selectedBrokerageExchanges,
      brokerageData: brokerageData ?? this.brokerageData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      leverageOptions: leverageOptions ?? this.leverageOptions,
      exchangeGroupOptions: exchangeGroupOptions ?? this.exchangeGroupOptions,
      selectedMaster: selectedMaster ?? this.selectedMaster,
      masterOptions: masterOptions ?? this.masterOptions,
    );
  }

  @override
  List<Object?> get props => [
    isEditMode,
    userType,
    userData,
    currentStep,
    totalSteps,
    name,
    username,
    password,
    confirmPassword,
    mobile,
    credit,
    leverage,
    creditLimit,
    remark,
    allowedDevice,
    cutOff,
    plSharing,
    brokerageSharing,
    squareOffTiming,
    specificTime,
    exchangeWiseBrk,
    symbolWiseBrk,
    selectedExchanges,
    exchangeGroups,
    selectedTradeLimits,
    triggerSettings,
    brokerageData,
    brokerageViewMode,
    selectedBrokerageExchanges,
    leverageOptions,
    exchangeGroupOptions,
    selectedExchangeSetting,
    allowSquareOff,
    marketOpenTimeRestriction,
    isSubmitting,
    isSuccess,
    error,
    selectedMaster,
    masterOptions,
  ];
}

class TriggerSetting {
  final String key;
  final String label;
  final String icon;
  const TriggerSetting({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class BrokerageData extends Equatable {
  final String exchange;
  final String turnoverWise;
  final String symbolWiseBrk;
  const BrokerageData({
    required this.exchange,
    required this.turnoverWise,
    required this.symbolWiseBrk,
  });
  BrokerageData copyWith({
    String? exchange,
    String? turnoverWise,
    String? symbolWiseBrk,
  }) {
    return BrokerageData(
      exchange: exchange ?? this.exchange,
      turnoverWise: turnoverWise ?? this.turnoverWise,
      symbolWiseBrk: symbolWiseBrk ?? this.symbolWiseBrk,
    );
  }

  @override
  List<Object?> get props => [exchange, turnoverWise, symbolWiseBrk];
}
