import 'package:equatable/equatable.dart';

abstract class SpraedReportEvent extends Equatable {
  const SpraedReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchSpraedReportEvent extends SpraedReportEvent {
  final String? exchange;

  const FetchSpraedReportEvent({this.exchange});

  @override
  List<Object?> get props => [exchange];
}
