import 'package:equatable/equatable.dart';
import '../../../domain/entities/spraed_report_entity.dart';

abstract class SpraedReportState extends Equatable {
  const SpraedReportState();

  @override
  List<Object?> get props => [];
}

class SpraedReportInitial extends SpraedReportState {}

class SpraedReportLoading extends SpraedReportState {}

class SpraedReportLoaded extends SpraedReportState {
  final List<SpraedReportEntity> data;

  const SpraedReportLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class SpraedReportError extends SpraedReportState {
  final String message;

  const SpraedReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
