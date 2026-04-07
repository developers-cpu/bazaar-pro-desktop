import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/surveillance/surveillance_data.dart';
import '../../../domain/usecases/surveillance/get_surveillance_data.dart';
import '../../../domain/usecases/surveillance/update_surveillance_data.dart';
import 'surveillance_event.dart';
import 'surveillance_state.dart';

class SurveillanceBloc extends Bloc<SurveillanceEvent, SurveillanceState> {
  final GetSurveillanceData getSurveillanceData;
  final UpdateSurveillanceData updateSurveillanceData;
  SurveillanceData? _currentData;
  SurveillanceBloc({
    required this.getSurveillanceData,
    required this.updateSurveillanceData,
  }) : super(SurveillanceInitial()) {
    on<LoadSurveillanceDataEvent>(_onLoadSurveillanceData);
    on<UpdateVpnRestrictionEvent>(_onUpdateVpnRestriction);
    on<UpdateTradeSlLimitEvent>(_onUpdateTradeSlLimit);
    on<UpdateSpotIndexSymbolsEvent>(_onUpdateSpotIndexSymbols);
    on<SaveSurveillanceDataEvent>(_onSaveSurveillanceData);
  }
  Future<void> _onLoadSurveillanceData(
    LoadSurveillanceDataEvent event,
    Emitter<SurveillanceState> emit,
  ) async {
    emit(SurveillanceLoading());
    final result = await getSurveillanceData();
    result.fold(
      (failure) => emit(SurveillanceError(message: failure.message)),
      (data) {
        _currentData = data;
        emit(SurveillanceLoaded(data: data));
      },
    );
  }

  void _onUpdateVpnRestriction(
    UpdateVpnRestrictionEvent event,
    Emitter<SurveillanceState> emit,
  ) {
    if (_currentData != null) {
      final updatedVpn = _currentData!.vpnRestriction.copyWith(
        masterRestriction: event.masterRestriction,
        clientRestriction: event.clientRestriction,
      );
      _currentData = _currentData!.copyWith(vpnRestriction: updatedVpn);
      emit(SurveillanceLoaded(data: _currentData!));
    }
  }

  void _onUpdateTradeSlLimit(
    UpdateTradeSlLimitEvent event,
    Emitter<SurveillanceState> emit,
  ) {
    if (_currentData == null || event.ids.isEmpty) return;

    final updatedOrders = _currentData!.bulkOrders.map((order) {
      if (!event.ids.contains(order.id)) {
        return order;
      }

      return order.copyWith(tradeSlLimit: event.tradeSlLimit);
    }).toList();

    _currentData = _currentData!.copyWith(bulkOrders: updatedOrders);
    emit(SurveillanceLoaded(data: _currentData!));
  }

  void _onUpdateSpotIndexSymbols(
    UpdateSpotIndexSymbolsEvent event,
    Emitter<SurveillanceState> emit,
  ) {
    if (_currentData == null) return;

    _currentData = _currentData!.copyWith(spotIndexSymbols: event.symbols);
    emit(SurveillanceLoaded(data: _currentData!));
  }

  Future<void> _onSaveSurveillanceData(
    SaveSurveillanceDataEvent event,
    Emitter<SurveillanceState> emit,
  ) async {
    if (_currentData == null) return;
    emit(SurveillanceLoading());
    final result = await updateSurveillanceData(_currentData!);
    result.fold(
      (failure) => emit(
        SurveillanceError(message: failure.message, currentData: _currentData),
      ),
      (_) => emit(
        SurveillanceUpdateSuccess(
          data: _currentData!,
          message: 'Updated Successfully',
        ),
      ),
    );
  }
}
