import 'package:bazarpro/features/report/domain/usecases/exchange_wise_pl/get_exchange_wise_pl_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazarpro/features/report/domain/entities/exchange_wise_pl/exchange_wise_pl_report.dart';
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
      (reports) {
        final aggregatedMap = <String, ExchangeWisePLReport>{};
        for (var report in reports) {
          final baseExchange = report.exchange.split('_').first;
          if (aggregatedMap.containsKey(baseExchange)) {
            final existing = aggregatedMap[baseExchange]!;
            aggregatedMap[baseExchange] = ExchangeWisePLReport(
              exchange: baseExchange,
              m2m: existing.m2m + report.m2m,
              realisedPL: existing.realisedPL + report.realisedPL,
              brokerage: existing.brokerage + report.brokerage,
              totalPL: existing.totalPL + report.totalPL,
              ourPercent: existing.ourPercent + report.ourPercent,
            );
          } else {
            aggregatedMap[baseExchange] = ExchangeWisePLReport(
              exchange: baseExchange,
              m2m: report.m2m,
              realisedPL: report.realisedPL,
              brokerage: report.brokerage,
              totalPL: report.totalPL,
              ourPercent: report.ourPercent,
            );
          }
        }
        emit(ExchangeWisePLLoaded(reports: aggregatedMap.values.toList()));
      },
    );
  }
}
