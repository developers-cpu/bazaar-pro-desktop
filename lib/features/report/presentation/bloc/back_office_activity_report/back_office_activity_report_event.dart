import 'package:equatable/equatable.dart';

abstract class BackOfficeActivityReportEvent extends Equatable {
  const BackOfficeActivityReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadBackOfficeActivityReport extends BackOfficeActivityReportEvent {
  const LoadBackOfficeActivityReport();
}
