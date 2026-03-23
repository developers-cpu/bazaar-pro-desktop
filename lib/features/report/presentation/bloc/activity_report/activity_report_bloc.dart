import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_activity_report.dart';
import 'activity_report_event.dart';
import 'activity_report_state.dart';

class ActivityReportBloc
    extends Bloc<ActivityReportEvent, ActivityReportState> {
  final GetActivityReportUseCase getActivityReport;
  ActivityReportBloc({required this.getActivityReport})
    : super(ActivityReportInitial()) {
    on<LoadActivityReport>(_onLoadActivityReport);
    on<FilterActivityReport>(_onFilterActivityReport);
    on<ResetActivityReportFilters>(_onResetActivityReportFilters);
  }
  Future<void> _onLoadActivityReport(
    LoadActivityReport event,
    Emitter<ActivityReportState> emit,
  ) async {
    emit(ActivityReportLoading());
    final result = await getActivityReport();
    result.fold(
      (failure) =>
          emit(const ActivityReportError(message: 'Failed to load data')),
      (data) {
        final users = data.map((e) => e.userName).toSet().toList()..sort();
        emit(ActivityReportLoaded(reports: data, users: users));
      },
    );
  }

  Future<void> _onFilterActivityReport(
    FilterActivityReport event,
    Emitter<ActivityReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is ActivityReportLoaded) {
      final userType = event.userType ?? currentState.selectedUserType;
      final user = event.user ?? currentState.selectedUser;
      final dateRange = event.dateRange ?? currentState.selectedDateRange;
      final editUserType =
          event.editUserType ?? currentState.selectedEditUserType;
      final result = await getActivityReport(
        user: user,
        startDate: dateRange?.start,
        endDate: dateRange?.end,
        editUserType: editUserType,
      );
      result.fold(
        (failure) =>
            emit(const ActivityReportError(message: 'Failed to filter data')),
        (data) => emit(
          currentState.copyWith(
            reports: data,
            selectedUserType: userType,
            selectedUser: user,
            selectedDateRange: dateRange,
            selectedEditUserType: editUserType,
          ),
        ),
      );
    }
  }

  Future<void> _onResetActivityReportFilters(
    ResetActivityReportFilters event,
    Emitter<ActivityReportState> emit,
  ) async {
    emit(ActivityReportLoading());
    final result = await getActivityReport();
    result.fold(
      (failure) =>
          emit(const ActivityReportError(message: 'Failed to reset data')),
      (data) {
        final users = data.map((e) => e.userName).toSet().toList()..sort();
        emit(
          ActivityReportLoaded(
            reports: data,
            users: users,
            selectedUserType: null,
            selectedUser: null,
            selectedDateRange: null,
            selectedEditUserType: null,
          ),
        );
      },
    );
  }
}
