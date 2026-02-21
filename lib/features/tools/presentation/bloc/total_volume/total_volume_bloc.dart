import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/total_volume_entity.dart';
import '../../../domain/usecases/get_total_volume_usecase.dart';
import '../../../../users/domain/usecases/user/get_exchanges.dart'
    as user_exchanges;

part 'total_volume_event.dart';
part 'total_volume_state.dart';

class TotalVolumeBloc extends Bloc<TotalVolumeEvent, TotalVolumeState> {
  final GetTotalVolumeUseCase getTotalVolume;
  final user_exchanges.GetExchanges getExchanges;

  TotalVolumeBloc({required this.getTotalVolume, required this.getExchanges})
    : super(const TotalVolumeState()) {
    on<GetTotalVolumeEvent>(_onGetTotalVolume);
    on<GetTotalVolumeExchangesEvent>(_onGetExchanges);
  }

  Future<void> _onGetExchanges(
    GetTotalVolumeExchangesEvent event,
    Emitter<TotalVolumeState> emit,
  ) async {
    emit(state.copyWith(exchangeStatus: ExchangeStatus.loading));
    final failureOrExchanges = await getExchanges();
    failureOrExchanges.fold(
      (failure) => emit(
        state.copyWith(
          exchangeStatus: ExchangeStatus.error,
          errorMessage: 'Failed to load exchanges',
        ),
      ),
      (exchanges) {



        emit(
          state.copyWith(
            exchangeStatus: ExchangeStatus.success,
            exchanges: exchanges,
          ),
        );
      },
    );
  }

  Future<void> _onGetTotalVolume(
    GetTotalVolumeEvent event,
    Emitter<TotalVolumeState> emit,
  ) async {
    emit(state.copyWith(status: TotalVolumeStatus.loading));
    final failureOrVolume = await getTotalVolume(event.exchange);
    failureOrVolume.fold(
      (failure) => emit(
        state.copyWith(
          status: TotalVolumeStatus.error,
          errorMessage: 'Server Failure',
        ),
      ),
      (volume) => emit(
        state.copyWith(status: TotalVolumeStatus.success, totalVolume: volume),
      ),
    );
  }
}
