import 'package:equatable/equatable.dart';


class UserFormState extends Equatable {
  
  final bool isEditMode;

  final String userType;

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

  const UserFormState({
    this.isEditMode = false,
    this.userType = 'Master',
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
  ];

  
  static const List<TriggerSetting> masterTriggerSettings = [
    TriggerSetting(key: 'addMaster', label: 'Add Master', icon: 'add_master'),
    TriggerSetting(key: 'addClient', label: 'Add Client', icon: 'add_client'),
    TriggerSetting(
      key: 'editPermission',
      label: 'Edit Permission',
      icon: 'edit_permission',
    ),
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
    TriggerSetting(key: 'tradeLock', label: 'Trade Lock', icon: 'trade_lock'),
    TriggerSetting(key: 'closeMode', label: 'Close Mode', icon: 'close_mode'),
    TriggerSetting(
      key: 'symbolWiseSLLimit',
      label: 'Symbol wise SL/Limit (%)',
      icon: 'symbol_wise',
    ),
    TriggerSetting(
      key: 'canTradeForClient',
      label: 'Can Trade For Client',
      icon: 'can_trade',
    ),
    TriggerSetting(
      key: 'changePasswordFirstTime',
      label: 'Change Password at first time',
      icon: 'change_password',
    ),
    TriggerSetting(key: 'lockUser', label: 'Lock User', icon: 'lock_user'),
    TriggerSetting(key: 'status', label: 'Status', icon: 'status'),
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

  static List<TriggerSetting> getTriggerSettings(String userType) {
    return userType == 'Master' ? masterTriggerSettings : clientTriggerSettings;
  }

  static List<String> getStepTitles(String userType) {
    return userType == 'Master' ? masterStepTitles : clientStepTitles;
  }

  static int getTotalSteps(String userType) {
    return userType == 'Master' ? 7 : 5;
  }
  static const List<TriggerSetting> availableTriggerSettings =
      masterTriggerSettings;

  static Map<String, bool> get defaultTriggerSettings => {
    for (var setting in masterTriggerSettings) setting.key: false,
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
  }) {
    return UserFormState(
      isEditMode: isEditMode ?? this.isEditMode,
      userType: userType ?? this.userType,
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
    );
  }

  @override
  List<Object?> get props => [
    isEditMode,
    userType,
    currentStep,
    totalSteps,
    stepTitles,
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
    selectedExchanges,
    exchangeGroups,
    plSharing,
    brokerageSharing,
    selectedExchangeSetting,
    allowSquareOff,
    squareOffTiming,
    marketOpenTimeRestriction,
    specificTime,
    selectedTradeLimits,
    triggerSettings,
    brokerageViewMode,
    selectedBrokerageExchange,
    exchangeWiseBrk,
    symbolWiseBrk,
    selectedBrokerageExchanges,
    brokerageData,
    isSubmitting,
    error,
    isSuccess,
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
