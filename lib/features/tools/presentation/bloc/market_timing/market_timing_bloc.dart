import 'package:bazarpro/features/tools/domain/usecases/get_market_timing_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_timing_event.dart';
import 'market_timing_state.dart';

class MarketTimingBloc extends Bloc<MarketTimingEvent, MarketTimingState> {
  final GetMarketTimingUseCase getMarketTiming;

  MarketTimingBloc({required this.getMarketTiming})
    : super(MarketTimingInitial()) {
    on<GetMarketTimingEvent>(_onGetMarketTiming);
  }

  Future<void> _onGetMarketTiming(
    GetMarketTimingEvent event,
    Emitter<MarketTimingState> emit,
  ) async {
    emit(MarketTimingLoading());
    final result = await getMarketTiming(
      GetMarketTimingParams(exchange: event.exchange, date: event.date),
    );
    result.fold(
      (failure) =>
          emit(const MarketTimingError('Failed to load market timing')),
      (data) => emit(MarketTimingLoaded(data)),
    );
  }
}
