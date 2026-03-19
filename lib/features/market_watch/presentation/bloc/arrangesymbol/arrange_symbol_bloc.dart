import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/table/table_column_helper.dart';
import 'arrange_symbol_event.dart';
import 'arrange_symbol_state.dart';

class ArrangeSymbolBloc extends Bloc<ArrangeSymbolEvent, ArrangeSymbolState> {
  static final List<ColumnItem> _defaultColumns =
      TableColumnHelper.getDefaultColumns();
  List<ColumnItem> _savedColumns = List.from(_defaultColumns);
  ArrangeSymbolBloc() : super(const ArrangeSymbolState()) {
    on<LoadColumnsEvent>(_onLoadColumns);
    on<ToggleColumnEvent>(_onToggleColumn);
    on<ReorderColumnEvent>(_onReorderColumn);
    on<SaveColumnsEvent>(_onSaveColumns);
    on<ResizeColumnEvent>(_onResizeColumn);
    on<ResetColumnsEvent>(_onResetColumns);
    on<ResetColumnSizesEvent>(_onResetColumnSizes);
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

  void _onResizeColumn(
    ResizeColumnEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    final updatedColumns = state.columns.map((column) {
      if (column.id == event.columnId) {
        return column.copyWith(width: event.width);
      }
      return column;
    }).toList();
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
    emit(
      state.copyWith(
        columns: List.from(_defaultColumns),
        isSaved: true,
        resetCount: state.resetCount + 1,
      ),
    );
  }

  void _onResetColumnSizes(
    ResetColumnSizesEvent event,
    Emitter<ArrangeSymbolState> emit,
  ) {
    emit(state.copyWith(resetCount: state.resetCount + 1));
  }

  List<ColumnItem> get visibleColumns {
    return _savedColumns.where((c) => c.isVisible).toList();
  }
}