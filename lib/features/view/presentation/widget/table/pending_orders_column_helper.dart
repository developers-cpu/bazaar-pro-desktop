import '../../../../market_watch/presentation/bloc/arrangesymbol/arrange_symbol_state.dart';

/// Column configuration class for Pending Orders table
class PendingOrdersColumnConfig {
  final double baseWidth;
  final bool isNumeric;
  final String label;

  const PendingOrdersColumnConfig({
    required this.baseWidth,
    required this.isNumeric,
    required this.label,
  });

  /// Get width scaled by font size
  double getWidth(double fontSize) {
    final scaleFactor = fontSize / 13.0;
    return baseWidth * scaleFactor;
  }
}

/// Helper class for Pending Orders table columns
class PendingOrdersColumnHelper {
  PendingOrdersColumnHelper._();

  /// Column configurations map
  static const Map<String, PendingOrdersColumnConfig> columnConfigs = {
    'userId': PendingOrdersColumnConfig(
      baseWidth: 100,
      isNumeric: false,
      label: 'USER ID',
    ),
    'upline': PendingOrdersColumnConfig(
      baseWidth: 100,
      isNumeric: false,
      label: 'UPLINE',
    ),
    'exchange': PendingOrdersColumnConfig(
      baseWidth: 80,
      isNumeric: false,
      label: 'EXCH',
    ),
    'symbol': PendingOrdersColumnConfig(
      baseWidth: 120,
      isNumeric: false,
      label: 'SYMBOL',
    ),
    'buySell': PendingOrdersColumnConfig(
      baseWidth: 180,
      isNumeric: false,
      label: 'B/S',
    ),
    'qty': PendingOrdersColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'QTY',
    ),
    'lot': PendingOrdersColumnConfig(
      baseWidth: 80,
      isNumeric: true,
      label: 'LOT',
    ),
    'triggerPrice': PendingOrdersColumnConfig(
      baseWidth: 120,
      isNumeric: true,
      label: 'T. PRICE',
    ),
    'orderDateTime': PendingOrdersColumnConfig(
      baseWidth: 180,
      isNumeric: false,
      label: 'ORDER D/T',
    ),
    'modifyOrderDateTime': PendingOrdersColumnConfig(
      baseWidth: 180,
      isNumeric: false,
      label: 'MODIFY ORDER D/T',
    ),
    'orderType': PendingOrdersColumnConfig(
      baseWidth: 80,
      isNumeric: false,
      label: 'TYPE',
    ),
    'cmp': PendingOrdersColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'CMP',
    ),
    'rPrice': PendingOrdersColumnConfig(
      baseWidth: 100,
      isNumeric: true,
      label: 'R.PRICE',
    ),
    'deviceId': PendingOrdersColumnConfig(
      baseWidth: 280,
      isNumeric: false,
      label: 'DEVICE ID',
    ),
    'ipAddress': PendingOrdersColumnConfig(
      baseWidth: 120,
      isNumeric: false,
      label: 'IP ADDRESS',
    ),
  };

  /// Get default visible columns
  static List<ColumnItem> getDefaultColumns({bool showDeviceInfo = false}) {
    final columns = [
      const ColumnItem(id: 'userId', name: 'USER ID', isVisible: true),
      const ColumnItem(id: 'upline', name: 'UPLINE', isVisible: true),
      const ColumnItem(id: 'exchange', name: 'EXCH', isVisible: true),
      const ColumnItem(id: 'symbol', name: 'SYMBOL', isVisible: true),
      const ColumnItem(id: 'buySell', name: 'B/S', isVisible: true),
      const ColumnItem(id: 'qty', name: 'QTY', isVisible: true),
      const ColumnItem(id: 'lot', name: 'LOT', isVisible: true),
      const ColumnItem(id: 'triggerPrice', name: 'T. PRICE', isVisible: true),
      const ColumnItem(id: 'orderDateTime', name: 'ORDER D/T', isVisible: true),
      const ColumnItem(id: 'modifyOrderDateTime', name: 'MODIFY ORDER D/T', isVisible: true),
      const ColumnItem(id: 'orderType', name: 'TYPE', isVisible: true),
      const ColumnItem(id: 'cmp', name: 'CMP', isVisible: true),
      const ColumnItem(id: 'rPrice', name: 'R.PRICE', isVisible: true),
    ];

    if (showDeviceInfo) {
      columns.addAll([
        const ColumnItem(id: 'deviceId', name: 'DEVICE ID', isVisible: true),
        const ColumnItem(id: 'ipAddress', name: 'IP ADDRESS', isVisible: true),
      ]);
    }

    return columns;
  }

  /// Calculate minimum width for all visible columns
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

  /// Get config for a column
  static PendingOrdersColumnConfig? getConfig(String columnId) {
    return columnConfigs[columnId];
  }

  /// Get label for a column
  static String getLabel(String columnId) {
    return columnConfigs[columnId]?.label ?? '';
  }

  /// Check if column is numeric
  static bool isNumeric(String columnId) {
    return columnConfigs[columnId]?.isNumeric ?? false;
  }
}