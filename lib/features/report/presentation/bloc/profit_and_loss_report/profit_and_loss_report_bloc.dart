import 'package:bazarpro/features/report/domain/entities/profit_and_loss_report.dart';
import 'package:bazarpro/features/report/domain/usecases/get_profit_and_loss_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profit_and_loss_report_event.dart';
import 'profit_and_loss_report_state.dart';
class ProfitAndLossReportBloc
    extends Bloc<ProfitAndLossReportEvent, ProfitAndLossReportState> {
  final GetProfitAndLossReportUseCase getProfitAndLossReport;
  List<ProfitAndLossReport> _allReports = [];
  ProfitAndLossReportBloc({required this.getProfitAndLossReport})
    : super(ProfitAndLossReportInitial()) {
    on<LoadProfitAndLossReport>(_onLoadProfitAndLossReport);
    on<FilterProfitAndLossReport>(_onFilterProfitAndLossReport);
    on<ResetProfitAndLossReportFilters>(_onResetProfitAndLossReportFilters);
  }
  Future<void> _onLoadProfitAndLossReport(
    LoadProfitAndLossReport event,
    Emitter<ProfitAndLossReportState> emit,
  ) async {
    emit(ProfitAndLossReportLoading());
    final result = await getProfitAndLossReport();
    result.fold(
      (failure) => emit(ProfitAndLossReportError(message: failure.message)),
      (reports) {
        _allReports = reports;
        final userNames = reports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(ProfitAndLossReportLoaded(reports: reports, userNames: userNames));
      },
    );
  }
  Future<void> _onFilterProfitAndLossReport(
    FilterProfitAndLossReport event,
    Emitter<ProfitAndLossReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfitAndLossReportLoaded) {
      emit(ProfitAndLossReportLoading());
      final result = await getProfitAndLossReport(userId: event.userId);
      result.fold(
        (failure) => emit(ProfitAndLossReportError(message: failure.message)),
        (filteredReports) {
          final userNames = _allReports.map((e) => e.userName).toSet().toList()
            ..sort();
          emit(
            ProfitAndLossReportLoaded(
              reports: filteredReports,
              userNames: userNames,
              selectedUser: event.userId,
            ),
          );
        },
      );
    }
  }
  Future<void> _onResetProfitAndLossReportFilters(
    ResetProfitAndLossReportFilters event,
    Emitter<ProfitAndLossReportState> emit,
  ) async {
    emit(ProfitAndLossReportLoading());
    final result = await getProfitAndLossReport();
    result.fold(
      (failure) => emit(ProfitAndLossReportError(message: failure.message)),
      (reports) {
        final userNames = reports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(
          ProfitAndLossReportLoaded(
            reports: reports,
            userNames: userNames,
            selectedUser: null,
          ),
        );
      },
    );
  }
}
