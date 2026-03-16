import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_settlement_sharing_report.dart';
import 'settlement_sharing_report_event.dart';
import 'settlement_sharing_report_state.dart';
class SettlementSharingReportBloc
    extends Bloc<SettlementSharingReportEvent, SettlementSharingReportState> {
  final GetSettlementSharingReport getSettlementSharingReport;
  SettlementSharingReportBloc({required this.getSettlementSharingReport})
    : super(SettlementSharingReportInitial()) {
    on<LoadSettlementSharingReport>(_onLoadSettlementSharingReport);
    on<SelectUserForDetail>(_onSelectUserForDetail);
    on<ClearSelectedUser>(_onClearSelectedUser);
  }
  Future<void> _onLoadSettlementSharingReport(
    LoadSettlementSharingReport event,
    Emitter<SettlementSharingReportState> emit,
  ) async {
    emit(SettlementSharingReportLoading());
    final failureOrReport = await getSettlementSharingReport(
      GetSettlementSharingReportParams(
        dateRange: event.dateRange,
        userId: event.userId,
      ),
    );
    failureOrReport.fold(
      (failure) => emit(SettlementSharingReportError(message: failure.message)),
      (report) {
        emit(
          SettlementSharingReportLoaded(
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
    Emitter<SettlementSharingReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettlementSharingReportLoaded) {
      emit(SettlementSharingReportLoading());
      final failureOrReport = await getSettlementSharingReport(
        GetSettlementSharingReportParams(
          dateRange: currentState.selectedDateRange,
          userId: event.userId,
        ),
      );
      failureOrReport.fold(
        (failure) =>
            emit(SettlementSharingReportError(message: failure.message)),
        (report) => emit(
          SettlementSharingReportLoaded(
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
    Emitter<SettlementSharingReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is SettlementSharingReportLoaded) {
      add(
        LoadSettlementSharingReport(
          dateRange: currentState.selectedDateRange,
          userId: null,
        ),
      );
    }
  }
}
