import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_back_office_activity_report.dart';
import 'back_office_activity_report_event.dart';
import 'back_office_activity_report_state.dart';

class BackOfficeActivityReportBloc
    extends Bloc<BackOfficeActivityReportEvent, BackOfficeActivityReportState> {
  final GetBackOfficeActivityReportUseCase getBackOfficeActivityReport;
  BackOfficeActivityReportBloc({required this.getBackOfficeActivityReport})
    : super(BackOfficeActivityReportInitial()) {
    on<LoadBackOfficeActivityReport>(_onLoad);
  }
  Future<void> _onLoad(
    LoadBackOfficeActivityReport event,
    Emitter<BackOfficeActivityReportState> emit,
  ) async {
    emit(BackOfficeActivityReportLoading());
    final result = await getBackOfficeActivityReport();
    result.fold(
      (failure) => emit(
        const BackOfficeActivityReportError(message: 'Failed to load data'),
      ),
      (data) => emit(BackOfficeActivityReportLoaded(reports: data)),
    );
  }
}