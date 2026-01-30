import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_brokerage_setting.dart';

abstract class UserBrokerageState extends Equatable {
  const UserBrokerageState();

  @override
  List<Object?> get props => [];
}

class UserBrokerageLoading extends UserBrokerageState {}

class UserBrokerageLoaded extends UserBrokerageState {
  final List<UserBrokerageSetting> allSettings;
  final List<UserBrokerageSetting> filteredSettings;
  final String viewType; // 'Exchange' or 'Symbol'
  final String? selectedExchange;
  final String? selectedSymbol;

  const UserBrokerageLoaded({
    this.allSettings = const [],
    this.filteredSettings = const [],
    this.viewType = 'Exchange',
    this.selectedExchange,
    this.selectedSymbol,
  });

  UserBrokerageLoaded copyWith({
    List<UserBrokerageSetting>? allSettings,
    List<UserBrokerageSetting>? filteredSettings,
    String? viewType,
    String? selectedExchange,
    String? selectedSymbol,
  }) {
    return UserBrokerageLoaded(
      allSettings: allSettings ?? this.allSettings,
      filteredSettings: filteredSettings ?? this.filteredSettings,
      viewType: viewType ?? this.viewType,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
    );
  }

  @override
  List<Object?> get props => [
    allSettings,
    filteredSettings,
    viewType,
    selectedExchange,
    selectedSymbol,
  ];
}

class UserBrokerageError extends UserBrokerageState {
  final String message;
  const UserBrokerageError(this.message);

  @override
  List<Object?> get props => [message];
}
