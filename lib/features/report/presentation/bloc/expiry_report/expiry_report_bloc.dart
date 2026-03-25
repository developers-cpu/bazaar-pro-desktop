import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_expiry_report.dart';
import 'expiry_report_event.dart';
import 'expiry_report_state.dart';

class ExpiryReportBloc extends Bloc<ExpiryReportEvent, ExpiryReportState> {
  final GetExpiryReport getExpiryReport;

  ExpiryReportBloc({
    required this.getExpiryReport,
  }) : super(ExpiryReportInitial()) {
    on<LoadExpiryReport>(_onLoadExpiryReport);
  }

  Future<void> _onLoadExpiryReport(
    LoadExpiryReport event,
    Emitter<ExpiryReportState> emit,
  ) async {
    emit(const ExpiryReportLoading());
    
    final result = await getExpiryReport(
      exchange: event.exchange,
      month: event.month,
    );

    result.fold(
      (failure) => emit(ExpiryReportError(message: failure.message)),
      (data) => emit(ExpiryReportLoaded(
        data: data,
        currentExchange: event.exchange,
        currentMonth: event.month,
      )),
    );
  }
}
