import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_spraed_report.dart';
import 'spraed_report_event.dart';
import 'spraed_report_state.dart';

class SpraedReportBloc extends Bloc<SpraedReportEvent, SpraedReportState> {
  final GetSpraedReportUseCase getSpraedReportUseCase;

  SpraedReportBloc({required this.getSpraedReportUseCase}) : super(SpraedReportInitial()) {
    on<FetchSpraedReportEvent>(_onFetchSpraedReport);
  }

  Future<void> _onFetchSpraedReport(
    FetchSpraedReportEvent event,
    Emitter<SpraedReportState> emit,
  ) async {
    emit(SpraedReportLoading());
    final result = await getSpraedReportUseCase(Params(exchange: event.exchange));
    result.fold(
      (failure) => emit(SpraedReportError(message: failure.message)),
      (data) => emit(SpraedReportLoaded(data: data)),
    );
  }
}
