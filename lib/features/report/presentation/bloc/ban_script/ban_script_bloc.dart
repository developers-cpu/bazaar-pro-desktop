import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_ban_script.dart';
import 'ban_script_event.dart';
import 'ban_script_state.dart';

class BanScriptBloc extends Bloc<BanScriptEvent, BanScriptState> {
  final GetBanScriptUseCase getBanScriptUseCase;

  BanScriptBloc({required this.getBanScriptUseCase}) : super(BanScriptInitial()) {
    on<FetchBanScriptEvent>(_onFetchBanScript);
  }

  Future<void> _onFetchBanScript(
    FetchBanScriptEvent event,
    Emitter<BanScriptState> emit,
  ) async {
    emit(BanScriptLoading());
    final result = await getBanScriptUseCase(
      BanScriptParams(exchange: event.exchange, banType: event.banType),
    );
    result.fold(
      (failure) => emit(BanScriptError(message: failure.message)),
      (data) => emit(BanScriptLoaded(
        data: data,
        currentExchange: event.exchange,
        currentBanType: event.banType,
      )),
    );
  }
}
