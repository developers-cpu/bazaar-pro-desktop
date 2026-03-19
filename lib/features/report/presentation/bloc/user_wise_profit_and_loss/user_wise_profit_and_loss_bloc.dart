import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_wise_profit_and_loss_report.dart';
import '../../../domain/usecases/get_user_wise_profit_and_loss_report.dart';
import 'user_wise_profit_and_loss_event.dart';
import 'user_wise_profit_and_loss_state.dart';

class UserWiseProfitAndLossBloc
    extends Bloc<UserWiseProfitAndLossEvent, UserWiseProfitAndLossState> {
  final GetUserWiseProfitAndLossReportUseCase getUserWiseProfitAndLossReport;
  List<UserWiseProfitAndLossReport> _allReports = [];
  UserWiseProfitAndLossBloc({required this.getUserWiseProfitAndLossReport})
    : super(UserWiseProfitAndLossInitial()) {
    on<LoadUserWiseProfitAndLoss>(_onLoadUserWiseProfitAndLoss);
    on<FilterUserWiseProfitAndLoss>(_onFilterUserWiseProfitAndLoss);
    on<ResetUserWiseProfitAndLossFilters>(_onResetFilters);
  }
  Future<void> _onLoadUserWiseProfitAndLoss(
    LoadUserWiseProfitAndLoss event,
    Emitter<UserWiseProfitAndLossState> emit,
  ) async {
    emit(UserWiseProfitAndLossLoading());
    final result = await getUserWiseProfitAndLossReport();
    result.fold(
      (failure) => emit(UserWiseProfitAndLossError(message: failure.message)),
      (reports) {
        _allReports = reports;
        final userNames = reports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(
          UserWiseProfitAndLossLoaded(reports: reports, userNames: userNames),
        );
      },
    );
  }

  Future<void> _onFilterUserWiseProfitAndLoss(
    FilterUserWiseProfitAndLoss event,
    Emitter<UserWiseProfitAndLossState> emit,
  ) async {
    emit(UserWiseProfitAndLossLoading());
    final result = await getUserWiseProfitAndLossReport(
      userId: event.userId,
      startDate: event.startDate,
      endDate: event.endDate,
    );
    result.fold(
      (failure) => emit(UserWiseProfitAndLossError(message: failure.message)),
      (reports) {
        final userNames = _allReports.map((e) => e.userName).toSet().toList()
          ..sort();
        emit(
          UserWiseProfitAndLossLoaded(
            reports: reports,
            userNames: userNames,
            startDate: event.startDate,
            endDate: event.endDate,
            selectedUser: event.userId,
          ),
        );
      },
    );
  }

  Future<void> _onResetFilters(
    ResetUserWiseProfitAndLossFilters event,
    Emitter<UserWiseProfitAndLossState> emit,
  ) async {
    add(LoadUserWiseProfitAndLoss());
  }
}