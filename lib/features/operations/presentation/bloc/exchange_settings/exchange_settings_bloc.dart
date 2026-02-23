import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../../../domain/repositories/exchange_settings/exchange_settings_repository.dart';
import '../../../domain/usecases/exchange_settings/get_exchange_settings.dart';
import '../../../domain/usecases/exchange_settings/update_exchange_settings.dart';
import 'exchange_settings_event.dart';
import 'exchange_settings_state.dart';

class ExchangeSettingsBloc
    extends Bloc<ExchangeSettingsEvent, ExchangeSettingsState> {
  final GetExchangeSettings getExchangeSettings;
  final UpdateExchangeSettings updateExchangeSettings;
  final ExchangeSettingsRepository repository;

  List<ExchangeSetting> _cachedSettings = [];
  List<DefaultSymbol> _cachedSymbols = [];

  ExchangeSettingsBloc({
    required this.getExchangeSettings,
    required this.updateExchangeSettings,
    required this.repository,
  }) : super(ExchangeSettingsInitial()) {
    on<LoadExchangeSettingsEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await getExchangeSettings(NoParams());
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to load settings')),
        (settings) {
          _cachedSettings = settings;
          _cachedSymbols = [];
          emit(ExchangeSettingsLoaded(settings));
        },
      );
    });

    on<UpdateExchangeSettingsEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await updateExchangeSettings(
        UpdateExchangeSettingsParams(ids: event.ids),
      );
      result.fold(
        (failure) => emit(const ExchangeSettingsError('Failed to update')),
        (success) {
          emit(
            const ExchangeSettingsUpdateSuccess(
              'Settings updated successfully',
            ),
          );
          add(LoadExchangeSettingsEvent());
        },
      );
    });

    on<LoadDefaultSymbolsEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await repository.getDefaultSymbols(
        exchange: event.exchange,
      );
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to load symbols')),
        (symbols) {
          _cachedSymbols = symbols.cast<DefaultSymbol>();
          emit(
            ExchangeSettingsLoaded(
              _cachedSettings,
              defaultSymbols: _cachedSymbols,
            ),
          );
        },
      );
    });
  }
}
