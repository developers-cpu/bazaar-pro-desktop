import 'package:equatable/equatable.dart';
import '../../../domain/entities/back_office_activity_report.dart';

abstract class BackOfficeActivityReportState extends Equatable {
  const BackOfficeActivityReportState();
  @override
  List<Object?> get props => [];
}

class BackOfficeActivityReportInitial extends BackOfficeActivityReportState {}

class BackOfficeActivityReportLoading extends BackOfficeActivityReportState {}

class BackOfficeActivityReportLoaded extends BackOfficeActivityReportState {
  final List<BackOfficeActivityReport> reports;
  const BackOfficeActivityReportLoaded({required this.reports});
  @override
  List<Object?> get props => [reports];
}

class BackOfficeActivityReportError extends BackOfficeActivityReportState {
  final String message;
  const BackOfficeActivityReportError({required this.message});
  @override
  List<Object> get props => [message];
}
