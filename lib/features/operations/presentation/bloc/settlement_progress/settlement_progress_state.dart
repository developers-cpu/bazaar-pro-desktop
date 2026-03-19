import 'package:equatable/equatable.dart';
import '../../../domain/entities/settlement_progress/bhav_copy_entity.dart';

abstract class SettlementProgressState extends Equatable {
  const SettlementProgressState();
  @override
  List<Object?> get props => [];
}

class SettlementProgressInitial extends SettlementProgressState {}

class SettlementProgressLoading extends SettlementProgressState {
  final String message;
  const SettlementProgressLoading({this.message = 'Loading...'});
  @override
  List<Object?> get props => [message];
}

class SettlementProgressError extends SettlementProgressState {
  final String message;
  const SettlementProgressError(this.message);
  @override
  List<Object?> get props => [message];
}

class BhavCopyPreviewReady extends SettlementProgressState {
  final List<BhavCopyEntity> previewData;
  const BhavCopyPreviewReady(this.previewData);
  @override
  List<Object?> get props => [previewData];
}

class SettlementProgressUpdating extends SettlementProgressState {}

class SettlementCompleted extends SettlementProgressState {}

class SettlementDataLoaded extends SettlementProgressState {
  final List<BhavCopyEntity> settlementData;
  final String activeExchange;
  const SettlementDataLoaded({
    required this.settlementData,
    required this.activeExchange,
  });
  @override
  List<Object?> get props => [settlementData, activeExchange];
}