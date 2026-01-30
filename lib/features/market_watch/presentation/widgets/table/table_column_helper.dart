import '../../bloc/arrangesymbol/arrange_symbol_state.dart';


class TableColumnConfig {
  final double baseWidth;
  final bool isNumeric;
  final String label;

  const TableColumnConfig({
    required this.baseWidth,
    required this.isNumeric,
    required this.label,
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
      baseWidth: 130,
      isNumeric: false,
      label: 'Exchange',
    ),
    'symbol': TableColumnConfig(
      baseWidth: 100,
      isNumeric: false,
      label: 'Symbol',
    ),
    'buyQty': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'Buy Qty',
    ),
    'buyPrice': TableColumnConfig(
      baseWidth: 110,
      isNumeric: true,
      label: 'Buy Price',
    ),
    'sellPrice': TableColumnConfig(
      baseWidth: 110,
      isNumeric: true,
      label: 'Sell Price',
    ),
    'sellQty': TableColumnConfig(
      baseWidth: 90,
      isNumeric: true,
      label: 'Sell Qty',
    ),
    'netChange': TableColumnConfig(
      baseWidth: 130,
      isNumeric: true,
      label: 'Net Change',
    ),
    'high': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'High',
    ),
    'low': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Low',
    ),
    'open': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Open',
    ),
    'close': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Close',
    ),
    'ltp': TableColumnConfig(
      baseWidth: 110,
      isNumeric: true,
      label: 'LTP',
    ),
    'netChangePercent': TableColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'Net Chg %',
    ),
    'expiry': TableColumnConfig(
      baseWidth: 90,
      isNumeric: false,
      label: 'Expiry',
    ),
    'lut': TableColumnConfig(
      baseWidth: 160,
      isNumeric: false,
      label: 'LUT',
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

  static double calculateMinWidth(List<ColumnItem> visibleColumns, double fontSize) {
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