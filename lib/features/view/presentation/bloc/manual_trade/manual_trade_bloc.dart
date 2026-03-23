import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'manual_trade_event.dart';
import 'manual_trade_state.dart';

class ManualTradeBloc extends Bloc<ManualTradeEvent, ManualTradeState> {
  ManualTradeBloc() : super(const ManualTradeState()) {
    on<LoadManualTradeDataEvent>(_onLoadData);
    on<UpdateManualTradeFieldEvent>(_onUpdateField);
    on<SubmitManualTradeEvent>(_onSubmitTrade);
    on<ConfirmManualTradeEvent>(_onConfirmTrade);
  }
  Future<void> _onLoadData(
    LoadManualTradeDataEvent event,
    Emitter<ManualTradeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final users = ['Demo02', 'Demo03', 'Client01'];
      final exchanges = ['NSE', 'MCX', 'CE/PE', 'OTHERS'];
      final symbols = ['REALINCE31DEC2025', 'NIFTY25N042555OCE', 'GOLD05DEC'];
      final initialSymbol = symbols.isNotEmpty ? symbols.first : null;
      final initialLot = '1';
      final initialQty =
          '${int.parse(initialLot) * _getLotSize(initialSymbol)}';
      emit(
        state.copyWith(
          isLoading: false,
          users: users,
          exchanges: exchanges,
          symbols: symbols,
          selectedUser: users.isNotEmpty ? users.first : null,
          selectedExchange: exchanges.isNotEmpty ? exchanges.first : null,
          selectedSymbol: initialSymbol,
          lot: initialLot,
          qty: initialQty,
          selectedTradeDisplay: 'Master',
          selectedDate: DateTime.now(),
          selectedTime: DateFormat('h:mm:ss a').format(DateTime.now()),
          deviceId: 'wgdhw5dhsq',
          device: 'IOS',
          ipAddress: '167.3895.463',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onUpdateField(
    UpdateManualTradeFieldEvent event,
    Emitter<ManualTradeState> emit,
  ) {
    switch (event.field) {
      case 'selectedUser':
        emit(state.copyWith(selectedUser: event.value as String?));
        break;
      case 'selectedExchange':
        emit(state.copyWith(selectedExchange: event.value as String?));
        break;
      case 'selectedSymbol':
        final symbol = event.value as String?;
        final qty = '${int.parse(state.lot) * _getLotSize(symbol)}';
        emit(state.copyWith(selectedSymbol: symbol, qty: qty));
        break;
      case 'qty':
        emit(state.copyWith(qty: event.value as String));
        break;
      case 'lot':
        final lot = event.value as String;
        final qty = '${int.parse(lot) * _getLotSize(state.selectedSymbol)}';
        emit(state.copyWith(lot: lot, qty: qty));
        break;
      case 'price':
        emit(state.copyWith(price: event.value as String));
        break;
      case 'isBrkCalculated':
        emit(state.copyWith(isBrkCalculated: event.value as bool));
        break;
      case 'selectedDate':
        emit(state.copyWith(selectedDate: event.value as DateTime?));
        break;
      case 'selectedTime':
        emit(state.copyWith(selectedTime: event.value as String));
        break;
      case 'selectedTradeDisplay':
        emit(state.copyWith(selectedTradeDisplay: event.value as String?));
        break;
      case 'deviceId':
        emit(state.copyWith(deviceId: event.value as String));
        break;
      case 'device':
        emit(state.copyWith(device: event.value as String));
        break;
      case 'ipAddress':
        emit(state.copyWith(ipAddress: event.value as String));
        break;
    }
  }

  int _getLotSize(String? symbol) {
    if (symbol == null) return 1;
    if (symbol.contains('NIFTY')) return 50;
    if (symbol.contains('BANKNIFTY')) return 15;
    if (symbol.contains('GOLD')) return 100;
    return 250;
  }

  void _onSubmitTrade(
    SubmitManualTradeEvent event,
    Emitter<ManualTradeState> emit,
  ) {
    if (state.qty.isEmpty || state.price.isEmpty) {
      emit(state.copyWith(error: 'Please fill all required fields'));
      return;
    }
    emit(state.copyWith(showConfirmDialog: true, error: null));
  }

  Future<void> _onConfirmTrade(
    ConfirmManualTradeEvent event,
    Emitter<ManualTradeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(
        state.copyWith(
          isLoading: false,
          showConfirmDialog: false,
          successMessage: 'Trade placed successfully',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
