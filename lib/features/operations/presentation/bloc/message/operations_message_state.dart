import 'package:equatable/equatable.dart';

enum OperationsMessageStatus { initial, loading, success, failure }

class OperationsMessageState extends Equatable {
  final int activeTab;
  final String rollType;
  final OperationsMessageStatus status;
  final String? message;
  const OperationsMessageState({
    this.activeTab = 0,
    this.rollType = 'Client',
    this.status = OperationsMessageStatus.initial,
    this.message,
  });
  OperationsMessageState copyWith({
    int? activeTab,
    String? rollType,
    OperationsMessageStatus? status,
    String? message,
  }) {
    return OperationsMessageState(
      activeTab: activeTab ?? this.activeTab,
      rollType: rollType ?? this.rollType,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [activeTab, rollType, status, message];
}