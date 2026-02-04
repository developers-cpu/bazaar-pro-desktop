import 'package:bazarpro/features/report/domain/usecases/exchange_wise_pl/get_exchange_wise_pl_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/usecases/usecase.dart';
import 'exchange_wise_pl_event.dart';
import 'exchange_wise_pl_state.dart';

class ExchangeWisePLBloc
    extends Bloc<ExchangeWisePLEvent, ExchangeWisePLState> {
  final GetExchangeWisePLReport getExchangeWisePLReport;

  ExchangeWisePLBloc({required this.getExchangeWisePLReport})
    : super(ExchangeWisePLInitial()) {
    on<LoadExchangeWisePL>(_onLoadExchangeWisePL);
  }

  Future<void> _onLoadExchangeWisePL(
    LoadExchangeWisePL event,
    Emitter<ExchangeWisePLState> emit,
  ) async {
    emit(ExchangeWisePLLoading());
    final result = await getExchangeWisePLReport(NoParams());

    result.fold(
      (failure) => emit(ExchangeWisePLError(message: failure.message)),
      (reports) => emit(ExchangeWisePLLoaded(reports: reports)),
    );
  }
}
