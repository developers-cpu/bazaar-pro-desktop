import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/exchange_settings/exchange_setting.dart';
import '../../../domain/entities/exchange_settings/market_timing.dart';
import '../../../domain/entities/exchange_settings/exchange_holiday.dart';
import '../../../domain/entities/exchange_settings/exchange_timing_detail.dart';
import '../../../domain/repositories/exchange_settings/exchange_settings_repository.dart';
import '../../../domain/usecases/exchange_settings/get_exchange_settings.dart';
import '../../../domain/usecases/exchange_settings/get_market_timings.dart';
import '../../../domain/usecases/exchange_settings/update_exchange_settings.dart';
import '../../../domain/usecases/exchange_settings/update_market_timings_from_excel.dart';
import 'exchange_settings_event.dart';
import 'exchange_settings_state.dart';

class ExchangeSettingsBloc
    extends Bloc<ExchangeSettingsEvent, ExchangeSettingsState> {
  final GetExchangeSettings getExchangeSettings;
  final UpdateExchangeSettings updateExchangeSettings;
  final ExchangeSettingsRepository repository;
  final GetMarketTimings getMarketTimings;
  final UpdateMarketTimingsFromExcel updateMarketTimingsFromExcel;

  List<ExchangeSetting> _cachedSettings = [];
  List<DefaultSymbol> _cachedSymbols = [];
  List<ExchangeMarketTiming> _cachedTimings = [];
  List<ExchangeHoliday> _cachedHolidays = [];
  List<ExchangeTimingDetail> _cachedTimingDetails = [];

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedExchange;

  ExchangeSettingsBloc({
    required this.getExchangeSettings,
    required this.updateExchangeSettings,
    required this.repository,
    required this.getMarketTimings,
    required this.updateMarketTimingsFromExcel,
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
          _cachedTimings = [];
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
              marketTimings: _cachedTimings,
            ),
          );
        },
      );
    });
    on<LoadMarketTimingsEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await getMarketTimings(NoParams());
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to load timings')),
        (timings) {
          _cachedTimings = List.from(timings);

          
          final exchanges = [
            'NSE',
            'MCX',
            'CE/PE',
            'GIFT',
            'OTHERS',
            'CRYPTO',
            'COMEX',
            'FOREX',
            'USSTOCK'
          ];
          final date = '13-04-2026';
          
          for (var exch in exchanges) {
            
            _cachedTimings.add(ExchangeMarketTiming(
              id: 'mock_${exch}_1',
              exchange: exch,
              date: date,
              timing: exch == 'MCX' || exch == 'GIFT' ? '09:00 AM - 11:30 PM' : '09:15 AM - 03:30 PM',
              isOn: true,
            ));

            
            if (exch == 'MCX') {
              _cachedTimings.add(ExchangeMarketTiming(
                id: 'mock_MCX_2',
                exchange: 'MCX',
                date: date,
                timing: '04:30 PM - 07:00 PM',
                isOn: true,
              ));
            }
          }
          _emitLoadedState(emit);
        },
      );
    });

    on<UpdateMarketTimingFiltersEvent>((event, emit) {
      _startDate = event.startDate;
      _endDate = event.endDate;
      _selectedExchange = event.exchange;
      _emitLoadedState(emit);
    });

    on<ApplyMarketTimingFiltersEvent>((event, emit) {
      _startDate = event.startDate;
      _endDate = event.endDate;
      _selectedExchange = event.exchange;
      add(LoadMarketTimingsEvent());
    });

    on<ResetMarketTimingFiltersEvent>((event, emit) {
      _startDate = null;
      _endDate = null;
      _selectedExchange = null;
      add(LoadMarketTimingsEvent());
    });
    on<UpdateMarketTimingsFromExcelEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await updateMarketTimingsFromExcel(
        UpdateMarketTimingsFromExcelParams(bytes: event.bytes),
      );
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to update from Excel')),
        (success) {
          emit(
            const ExchangeSettingsUpdateSuccess(
              'Market timings updated successfully from Excel',
            ),
          );
          add(LoadMarketTimingsEvent());
        },
      );
    });
    on<UpdateMarketTimingStatusEvent>((event, emit) async {
      final result = await repository.updateMarketTimingStatus(
        id: event.id,
        isOn: event.isOn,
      );
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to update status')),
        (success) {
          emit(
            const ExchangeSettingsUpdateSuccess(
              'Status updated successfully',
            ),
          );
          add(LoadMarketTimingsEvent());
        },
      );
    });

    on<LoadExchangeHolidaysEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await repository.getExchangeHolidays(
        exchange: event.exchange,
      );
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to load holidays')),
        (holidays) {
          _cachedHolidays = holidays;
          emit(ExchangeSettingsLoaded(
            _cachedSettings,
            defaultSymbols: _cachedSymbols,
            marketTimings: _cachedTimings,
            holidays: _cachedHolidays,
            timings: _cachedTimingDetails,
          ));
        },
      );
    });

    on<UpdateExchangeHolidayEvent>((event, emit) async {
      final result = await repository.updateExchangeHoliday(event.holiday);
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to update holiday')),
        (success) {
          emit(const ExchangeSettingsUpdateSuccess(
              'Holiday updated successfully'));
          add(LoadExchangeHolidaysEvent(exchange: event.holiday.exchange));
          add(LoadMarketTimingsEvent());
        },
      );
    });

    on<DeleteExchangeHolidayEvent>((event, emit) async {
      final result = await repository.deleteExchangeHoliday(event.id);
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to delete holiday')),
        (success) {
          emit(const ExchangeSettingsUpdateSuccess(
              'Holiday deleted successfully'));
          add(LoadExchangeHolidaysEvent(exchange: event.exchange));
        },
      );
    });

    on<LoadExchangeTimingsEvent>((event, emit) async {
      emit(ExchangeSettingsLoading());
      final result = await repository.getExchangeTimings(
        exchange: event.exchange,
      );
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to load timings')),
        (timings) {
          _cachedTimingDetails = timings;
          emit(ExchangeSettingsLoaded(
            _cachedSettings,
            defaultSymbols: _cachedSymbols,
            marketTimings: _cachedTimings,
            holidays: _cachedHolidays,
            timings: _cachedTimingDetails,
          ));
        },
      );
    });

    on<UpdateExchangeTimingEvent>((event, emit) async {
      final result = await repository.updateExchangeTiming(event.timing);
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to update timing')),
        (success) {
          emit(const ExchangeSettingsUpdateSuccess(
              'Timing updated successfully'));
          add(LoadExchangeTimingsEvent(exchange: event.timing.exchange));
          add(LoadMarketTimingsEvent());
        },
      );
    });

    on<DeleteExchangeTimingEvent>((event, emit) async {
      final result = await repository.deleteExchangeTiming(event.id);
      result.fold(
        (failure) =>
            emit(const ExchangeSettingsError('Failed to delete timing')),
        (success) {
          emit(const ExchangeSettingsUpdateSuccess(
              'Timing deleted successfully'));
          add(LoadExchangeTimingsEvent(exchange: event.exchange));
        },
      );
    });
  }

  void _emitLoadedState(Emitter<ExchangeSettingsState> emit) {
    List<ExchangeMarketTiming> filteredTimings = _cachedTimings;

    
    if (_selectedExchange != null && _selectedExchange != 'All') {
      filteredTimings = filteredTimings
          .where((t) => t.exchange.toLowerCase() == _selectedExchange!.toLowerCase())
          .toList();
    }

    
    if (_startDate != null && _endDate != null) {
      filteredTimings = filteredTimings.where((t) {
        try {
          final parts = t.date.split('-');
          if (parts.length != 3) return true;
          final date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          return (date.isAfter(_startDate!) || date.isAtSameMomentAs(_startDate!)) &&
                 (date.isBefore(_endDate!) || date.isAtSameMomentAs(_endDate!));
        } catch (_) {
          return true;
        }
      }).toList();
    }

    emit(ExchangeSettingsLoaded(
      _cachedSettings,
      defaultSymbols: _cachedSymbols,
      marketTimings: filteredTimings,
      holidays: _cachedHolidays,
      timings: _cachedTimingDetails,
      startDate: _startDate,
      endDate: _endDate,
      selectedExchange: _selectedExchange,
    ));
  }
}
