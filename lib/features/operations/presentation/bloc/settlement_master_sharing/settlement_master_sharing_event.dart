import 'package:equatable/equatable.dart';

abstract class SettlementMasterSharingEvent extends Equatable {
  const SettlementMasterSharingEvent();
  @override
  List<Object?> get props => [];
}

class LoadMastersEvent extends SettlementMasterSharingEvent {}

class SelectMasterEvent extends SettlementMasterSharingEvent {
  final String masterId;
  final String masterName;
  const SelectMasterEvent({required this.masterId, required this.masterName});
  @override
  List<Object?> get props => [masterId, masterName];
}

class LoadMasterSharingDataEvent extends SettlementMasterSharingEvent {
  final String? masterId;
  const LoadMasterSharingDataEvent({this.masterId});
  @override
  List<Object?> get props => [masterId];
}