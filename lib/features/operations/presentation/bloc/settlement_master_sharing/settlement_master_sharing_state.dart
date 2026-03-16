import 'package:equatable/equatable.dart';
import '../../../domain/entities/settlement_master_sharing.dart';
abstract class SettlementMasterSharingState extends Equatable {
  const SettlementMasterSharingState();
  @override
  List<Object?> get props => [];
}
class SettlementMasterSharingInitial extends SettlementMasterSharingState {}
class SettlementMasterSharingLoading extends SettlementMasterSharingState {}
class SettlementMasterSharingLoaded extends SettlementMasterSharingState {
  final List<MasterUser> masters;
  final List<MasterSharingEntry> entries;
  final int totalRecords;
  final String? selectedMasterId;
  final String? selectedMasterName;
  const SettlementMasterSharingLoaded({
    required this.masters,
    required this.entries,
    required this.totalRecords,
    this.selectedMasterId,
    this.selectedMasterName,
  });
  @override
  List<Object?> get props => [
    masters,
    entries,
    totalRecords,
    selectedMasterId,
    selectedMasterName,
  ];
}
class SettlementMasterSharingError extends SettlementMasterSharingState {
  final String message;
  const SettlementMasterSharingError({required this.message});
  @override
  List<Object?> get props => [message];
}
