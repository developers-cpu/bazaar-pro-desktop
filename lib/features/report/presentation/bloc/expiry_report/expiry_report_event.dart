import 'package:equatable/equatable.dart';

abstract class ExpiryReportEvent extends Equatable {
  const ExpiryReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpiryReport extends ExpiryReportEvent {
  final String? exchange;

  const LoadExpiryReport({this.exchange});

  @override
  List<Object?> get props => [exchange];
}
