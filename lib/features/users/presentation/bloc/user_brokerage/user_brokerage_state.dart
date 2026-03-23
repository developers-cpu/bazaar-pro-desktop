import 'package:bazarpro/features/users/domain/entities/user_brokerage_setting/user_brokerage_setting.dart';
import 'package:equatable/equatable.dart';

abstract class UserBrokerageState extends Equatable {
  const UserBrokerageState();
  @override
  List<Object?> get props => [];
}

class UserBrokerageInitial extends UserBrokerageState {}

class UserBrokerageLoading extends UserBrokerageState {}

class UserBrokerageLoaded extends UserBrokerageState {
  final List<UserBrokerageSetting> allSettings;
  final List<UserBrokerageSetting> filteredSettings;
  final String viewType;
  final String? selectedExchange;
  final String? selectedSymbol;
  final List<String> exchanges;
  final List<String> symbols;
  const UserBrokerageLoaded({
    required this.allSettings,
    required this.filteredSettings,
    this.viewType = 'Exchange',
    this.selectedExchange,
    this.selectedSymbol,
    this.exchanges = const [],
    this.symbols = const [],
  });
  UserBrokerageLoaded copyWith({
    List<UserBrokerageSetting>? allSettings,
    List<UserBrokerageSetting>? filteredSettings,
    String? viewType,
    String? selectedExchange,
    String? selectedSymbol,
    List<String>? exchanges,
    List<String>? symbols,
  }) {
    return UserBrokerageLoaded(
      allSettings: allSettings ?? this.allSettings,
      filteredSettings: filteredSettings ?? this.filteredSettings,
      viewType: viewType ?? this.viewType,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
    );
  }

  @override
  List<Object?> get props => [
    allSettings,
    filteredSettings,
    viewType,
    selectedExchange,
    selectedSymbol,
    exchanges,
    symbols,
  ];
}

class UserBrokerageError extends UserBrokerageState {
  final String message;
  const UserBrokerageError(this.message);
  @override
  List<Object?> get props => [message];
}
