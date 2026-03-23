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
      baseWidth: 90,
      isNumeric: false,
      label: 'Exchange',
      minWidth: 90,
    ),
    'symbol': TableColumnConfig(
      baseWidth: 110,
      isNumeric: false,
      label: 'Symbol',
      minWidth: 110,
    ),
    'buyQty': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'Buy Qty',
      minWidth: 80,
    ),
    'buyPrice': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'Buy Price',
      minWidth: 90,
    ),
    'sellPrice': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'Sell Price',
      minWidth: 90,
    ),
    'sellQty': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'Sell Qty',
      minWidth: 80,
    ),
    'netChange': TableColumnConfig(
      baseWidth: 95,
      isNumeric: true,
      label: 'Net Change',
      minWidth: 95,
    ),
    'high': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'High',
      minWidth: 80,
    ),
    'low': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'Low',
      minWidth: 80,
    ),
    'open': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'Open',
      minWidth: 80,
    ),
    'close': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'Close',
      minWidth: 80,
    ),
    'ltp': TableColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'LTP',
      minWidth: 80,
    ),
    'netChangePercent': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'Net Chg %',
      minWidth: 90,
    ),
    'expiry': TableColumnConfig(
      baseWidth: 80,
      isNumeric: false,
      label: 'Expiry',
      minWidth: 80,
    ),
    'lut': TableColumnConfig(
      baseWidth: 140,
      isNumeric: false,
      label: 'LUT',
      minWidth: 140,
    ),
    'strikePrice': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'STRIKE PRICE',
      minWidth: 100,
    ),
    'lowerCkt': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'LOWER CKT',
      minWidth: 90,
    ),
    'upperCkt': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'UPPER CKT',
      minWidth: 90,
    ),
    'tbq': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'TBQ',
      minWidth: 90,
    ),
    'tsq': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'TSQ',
      minWidth: 90,
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
      ColumnItem(id: 'strikePrice', name: 'STRIKE PRICE', isVisible: true),
      ColumnItem(id: 'lowerCkt', name: 'LOWER CKT', isVisible: true),
      ColumnItem(id: 'upperCkt', name: 'UPPER CKT', isVisible: true),
      ColumnItem(id: 'tbq', name: 'TBQ', isVisible: true),
      ColumnItem(id: 'tsq', name: 'TSQ', isVisible: true),
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
