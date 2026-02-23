import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_bill_generate_report.dart';
import 'bill_generate_event.dart';
import 'bill_generate_state.dart';
class BillGenerateBloc extends Bloc<BillGenerateEvent, BillGenerateState> {
  final GetBillGenerateReport getBillGenerateReport;
  BillGenerateBloc({required this.getBillGenerateReport})
    : super(BillGenerateInitial()) {
    on<LoadBillGenerateReport>(_onLoadBillGenerateReport);
    on<FilterBillGenerateReport>(_onFilterBillGenerateReport);
  }
  Future<void> _onLoadBillGenerateReport(
    LoadBillGenerateReport event,
    Emitter<BillGenerateState> emit,
  ) async {
    emit(BillGenerateLoading());
    final failureOrReport = await getBillGenerateReport(
      GetBillGenerateParams(
        userId: event.userId ?? '',
        billFormat: event.billFormat ?? 'Advance',
        billType: event.billType ?? 'PDF',
      ),
    );
    failureOrReport.fold(
      (failure) => emit(BillGenerateError(message: failure.message)),
      (report) => emit(
        BillGenerateLoaded(
          report: report,
          selectedUserId: event.userId,
          selectedBillFormat: event.billFormat,
          selectedBillType: event.billType,
        ),
      ),
    );
  }
  Future<void> _onFilterBillGenerateReport(
    FilterBillGenerateReport event,
    Emitter<BillGenerateState> emit,
  ) async {
    final currentState = state;
    if (currentState is BillGenerateLoaded) {
      add(
        LoadBillGenerateReport(
          userId: event.userId ?? currentState.selectedUserId,
          billFormat: event.billFormat ?? currentState.selectedBillFormat,
          billType: event.billType ?? currentState.selectedBillType,
        ),
      );
    } else {
      add(
        LoadBillGenerateReport(
          userId: event.userId,
          billFormat: event.billFormat,
          billType: event.billType,
        ),
      );
    }
  }
}
