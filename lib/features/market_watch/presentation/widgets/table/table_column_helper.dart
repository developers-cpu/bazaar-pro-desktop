import '../../bloc/arrangesymbol/arrange_symbol_state.dart';

class TableColumnConfig {
  final double baseWidth;
  final double minWidth;
  final bool isNumeric;
  final String label;
  const TableColumnConfig({
    required this.baseWidth,
    required this.isNumeric,
    required this.label,
    this.minWidth = 60,
  });
  double getWidth(double fontSize) {
    final scaleFactor = fontSize / 13.0;
    return baseWidth * scaleFactor;
  }
}

class TableColumnHelper {
  TableColumnHelper._();
  static const Map<String, TableColumnConfig> columnConfigs = {
    'exchange': TableColumnConfig(
      baseWidth: 120,
      isNumeric: false,
      label: 'Exchange',
      minWidth: 90,
    ),
    'symbol': TableColumnConfig(
      baseWidth: 100,
      isNumeric: false,
      label: 'Symbol',
      minWidth: 90,
    ),
    'buyQty': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Buy Qty',
      minWidth: 75,
    ),
    'buyPrice': TableColumnConfig(
      baseWidth: 120,
      isNumeric: true,
      label: 'Buy Price',
      minWidth: 85,
    ),
    'sellPrice': TableColumnConfig(
      baseWidth: 130,
      isNumeric: true,
      label: 'Sell Price',
      minWidth: 85,
    ),
    'sellQty': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Sell Qty',
      minWidth: 75,
    ),
    'netChange': TableColumnConfig(
      baseWidth: 200,
      isNumeric: true,
      label: 'Net Change',
      minWidth: 85,
    ),
    'high': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'High',
      minWidth: 75,
    ),
    'low': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Low',
      minWidth: 75,
    ),
    'open': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Open',
      minWidth: 75,
    ),
    'close': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Close',
      minWidth: 75,
    ),
    'ltp': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'LTP',
      minWidth: 85,
    ),
    'netChangePercent': TableColumnConfig(
      baseWidth: 150,
      isNumeric: true,
      label: 'Net Chg %',
      minWidth: 85,
    ),
    'expiry': TableColumnConfig(
      baseWidth: 100,
      isNumeric: false,
      label: 'Expiry',
      minWidth: 85,
    ),
    'lut': TableColumnConfig(
      baseWidth: 180,
      isNumeric: false,
      label: 'LUT',
      minWidth: 120,
    ),
  };
  static List<ColumnItem> getDefaultColumns() {
    return const [
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
  }

  static double calculateMinWidth(
    List<ColumnItem> visibleColumns,
    double fontSize,
  ) {
    double totalWidth = 0;
    for (final column in visibleColumns) {
      final config = columnConfigs[column.id];
      if (config != null) {
        totalWidth += config.getWidth(fontSize);
      }
    }
    return totalWidth;
  }

  static TableColumnConfig? getConfig(String columnId) {
    return columnConfigs[columnId];
  }

  static String getLabel(String columnId) {
    return columnConfigs[columnId]?.label ?? '';
  }

  static bool isNumeric(String columnId) {
    return columnConfigs[columnId]?.isNumeric ?? false;
  }
}
