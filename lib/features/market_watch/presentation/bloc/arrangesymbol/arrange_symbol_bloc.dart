import 'package:flutter_bloc/flutter_bloc.dart';
import 'arrange_symbol_event.dart';
import 'arrange_symbol_state.dart';

class ArrangeSymbolBloc extends Bloc<ArrangeSymbolEvent, ArrangeSymbolState> {
  static const List<ColumnItem> _defaultColumns = [
    ColumnItem(id: 'exchange', name: 'EXCHANGE', isVisible: true),
    ColumnItem(id: 'symbol', name: 'SYMBOL', isVisible: true),
    ColumnItem(id: 'buyQty', name: 'BUY QTY', isVisible: true),
    ColumnItem(id: 'buyPrice', name: 'BUY PRICE', isVisible: true),
    ColumnItem(id: 'sellPrice', name: 'SELL PRICE', isVisible: true),
    ColumnItem(id: 'sellQty', name: 'SELL QTY', isVisible: true),
    ColumnItem(id: 'netChange', name: 'NET CHANGE', isVisible: true),
    ColumnItem(id: 'high', name: 'HIGH', isVisible: true),
    ColumnItem(id: 'low', name: 'LOW', isVisible: true),
    ColumnItem(id: 'open', name: 'OPEN', isVisible: true),
    ColumnItem(id: 'close', name: 'CLOSE', isVisible: true),
    ColumnItem(id: 'ltp', name: 'LTP', isVisible: true),
    ColumnItem(id: 'netChangePercent', name: 'NET CHG %', isVisible: true),
    ColumnItem(id: 'expiry', name: 'EXPIRY', isVisible: true),
    ColumnItem(id: 'lut', name: 'LUT', isVisible: true),
  ];
  List<ColumnItem> _savedColumns = List.from(_defaultColumns);
  ArrangeSymbolBloc() : super(const ArrangeSymbolState()) {
    on<LoadColumnsEvent>(_onLoadColumns);
    on<ToggleColumnEvent>(_onToggleColumn);
    on<ReorderColumnEvent>(_onReorderColumn);
    on<SaveColumnsEvent>(_onSaveColumns);
    on<ResetColumnsEvent>(_onResetColumns);
  }
  void _onLoadColumns(
    LoadColumnsEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    emit(
      state.copyWith(
        columns: List.from(_savedColumns),
        isLoading: false,
        isSaved: false,
      ),
    );
  }

  void _onToggleColumn(
    ToggleColumnEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    final updatedColumns = state.columns.map((column) {
      if (column.id == event.columnId) {
        return column.copyWith(isVisible: !column.isVisible);
      }
      return column;
    }).toList();
    final visibleCount = updatedColumns.where((c) => c.isVisible).length;
    if (visibleCount == 0) {
      return;
    }
    emit(state.copyWith(columns: updatedColumns, isSaved: false));
  }

  void _onReorderColumn(
    ReorderColumnEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    final columns = List<ColumnItem>.from(state.columns);
    final item = columns.removeAt(event.oldIndex);
    int newIndex = event.newIndex;
    if (event.newIndex > event.oldIndex) {
      newIndex -= 1;
    }
    columns.insert(newIndex, item);
    emit(state.copyWith(columns: columns, isSaved: false));
  }

  void _onSaveColumns(
    SaveColumnsEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    _savedColumns = List.from(state.columns);
    emit(state.copyWith(isSaved: true));
  }

  void _onResetColumns(
    ResetColumnsEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    _savedColumns = List.from(_defaultColumns);
    emit(state.copyWith(columns: List.from(_defaultColumns), isSaved: true));
  }

  List<ColumnItem> get visibleColumns {
    return _savedColumns.where((c) => c.isVisible).toList();
  }
}
