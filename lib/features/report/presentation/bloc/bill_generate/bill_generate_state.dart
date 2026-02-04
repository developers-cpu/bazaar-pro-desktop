import 'package:equatable/equatable.dart';
import '../../../domain/entities/bill_generate_report.dart';
abstract class BillGenerateState extends Equatable {
  const BillGenerateState();
  @override
  List<Object?> get props => [];
}
class BillGenerateInitial extends BillGenerateState {}
class BillGenerateLoading extends BillGenerateState {}
class BillGenerateLoaded extends BillGenerateState {
  final BillGenerateReport report;
  final String? selectedUserId;
  final String? selectedBillFormat;
  final String? selectedBillType;
  const BillGenerateLoaded({
    required this.report,
    this.selectedUserId,
    this.selectedBillFormat,
    this.selectedBillType,
  });
  BillGenerateLoaded copyWith({
    BillGenerateReport? report,
    String? selectedUserId,
    String? selectedBillFormat,
    String? selectedBillType,
  }) {
    return BillGenerateLoaded(
      report: report ?? this.report,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      selectedBillFormat: selectedBillFormat ?? this.selectedBillFormat,
      selectedBillType: selectedBillType ?? this.selectedBillType,
    );
  }
  @override
  List<Object?> get props => [
    report,
    selectedUserId,
    selectedBillFormat,
    selectedBillType,
  ];
}
class BillGenerateError extends BillGenerateState {
  final String message;
  const BillGenerateError({required this.message});
  @override
  List<Object?> get props => [message];
}
