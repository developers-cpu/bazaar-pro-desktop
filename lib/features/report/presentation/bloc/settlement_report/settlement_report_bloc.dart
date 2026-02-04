import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_settlement_report.dart';
import 'settlement_report_event.dart';
import 'settlement_report_state.dart';

class SettlementReportBloc
    extends Bloc<SettlementReportEvent, SettlementReportState> {
  final GetSettlementReport getSettlementReport;

  SettlementReportBloc({required this.getSettlementReport})
    : super(SettlementReportInitial()) {
    on<LoadSettlementReport>(_onLoadSettlementReport);
    on<SelectUserForDetail>(_onSelectUserForDetail);
    on<ClearSelectedUser>(_onClearSelectedUser);
  }

  Future<void> _onLoadSettlementReport(
    LoadSettlementReport event,
    Emitter<SettlementReportState> emit,
  ) async {
    emit(SettlementReportLoading());

    final failureOrReport = await getSettlementReport(
      GetSettlementReportParams(
        dateRange: event.dateRange,
        userId: event.userId,
      ),
    );

    failureOrReport.fold(
      (failure) => emit(SettlementReportError(message: failure.message)),
      (report) {




        emit(
          SettlementReportLoaded(
            report: report,
            selectedDateRange: event.dateRange,
            selectedUserId: event.userId,
          ),
        );
      },
    );
  }

  Future<void> _onSelectUserForDetail(
    SelectUserForDetail event,
    Emitter<SettlementReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettlementReportLoaded) {
      emit(SettlementReportLoading());

      final failureOrReport = await getSettlementReport(
        GetSettlementReportParams(
          dateRange: currentState.selectedDateRange,
          userId: event.userId,
        ),
      );

      failureOrReport.fold(
        (failure) => emit(SettlementReportError(message: failure.message)),
        (report) => emit(
          SettlementReportLoaded(
            report: report,
            selectedDateRange: currentState.selectedDateRange,
            selectedUserId: event.userId,
            selectedUserName: event.username,
          ),
        ),
      );
    }
  }

  Future<void> _onClearSelectedUser(
    ClearSelectedUser event,
    Emitter<SettlementReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettlementReportLoaded) {
      add(
        LoadSettlementReport(
          dateRange: currentState.selectedDateRange,
          userId: null,
        ),
      );
    }
  }
}
