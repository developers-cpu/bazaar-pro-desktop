import 'package:equatable/equatable.dart';

abstract class ExpiryReportEvent extends Equatable {
  const ExpiryReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpiryReport extends ExpiryReportEvent {
  final String? exchange;
  final String? month;

  const LoadExpiryReport({this.exchange, this.month});

  @override
  List<Object?> get props => [exchange, month];
}
