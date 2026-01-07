
import 'package:equatable/equatable.dart';

class ColumnItem extends Equatable {
  final String id;
  final String name;
  final bool isVisible;

  const ColumnItem({
    required this.id,
    required this.name,
    this.isVisible = true,
  });

  ColumnItem copyWith({String? id, String? name, bool? isVisible}) {
    return ColumnItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [id, name, isVisible];
}

class ArrangeSymbolState extends Equatable {
  final List<ColumnItem> columns;
  final bool isLoading;
  final bool isSaved;

  const ArrangeSymbolState({
    this.columns = const [],
    this.isLoading = false,
    this.isSaved = false,
  });

  ArrangeSymbolState copyWith({
    List<ColumnItem>? columns,
    bool? isLoading,
    bool? isSaved,
  }) {
    return ArrangeSymbolState(
      columns: columns ?? this.columns,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [columns, isLoading, isSaved];
}