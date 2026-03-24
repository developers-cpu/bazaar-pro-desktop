import 'package:equatable/equatable.dart';
import '../../../data/models/expiry_report_model.dart';

abstract class ExpiryReportState extends Equatable {
  const ExpiryReportState();

  @override
  List<Object?> get props => [];
}

class ExpiryReportInitial extends ExpiryReportState {}

class ExpiryReportLoading extends ExpiryReportState {
  final bool isPagination;
  const ExpiryReportLoading({this.isPagination = false});
  
  @override
  List<Object?> get props => [isPagination];
}

class ExpiryReportLoaded extends ExpiryReportState {
  final List<ExpiryReportModel> data;
  final String? currentExchange;

  const ExpiryReportLoaded({
    required this.data,
    this.currentExchange,
  });

  @override
  List<Object?> get props => [data, currentExchange];
}

class ExpiryReportError extends ExpiryReportState {
  final String message;

  const ExpiryReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
