/// Application wide string constants
/// Contains all text strings used throughout the app for easy localization and maintenance
class AppStrings {
  // Prevent instantiation
  AppStrings._();

  // App title
  static const String appTitle = 'Market Watch';
  
  // Table headers
  static const String exchange = 'EXCHANGE';
  static const String symbol = 'SYMBOL';
  static const String buyQty = 'BUY QTY';
  static const String buyPrice = 'BUY PRICE';
  static const String sellPrice = 'SELL PRICE';
  static const String sellQty = 'SELL QTY';
  static const String netChange = 'NET CHANGE';
  static const String high = 'HIGH';
  static const String low = 'LOW';
  static const String open = 'OPEN';
  static const String close = 'CLOSE';
  static const String ltp = 'LTP';
  static const String netChangePercent = 'NET CHANGE%';
  static const String expiry = 'EXPIRY';
  static const String lut = 'LUT';
  
  // Context menu items
  static const String viewChart = 'View Chart';
  static const String arrangeSymbol = 'Arrange Symbol';
  static const String setSymbolFont = 'Set Symbol Font';
  static const String fitToSize = 'Fit to Size';
  static const String symbolInfo = 'Symbol Info';
  static const String grid = 'Grid';
  static const String cut = 'Cut ( Ctrl + X )';
  static const String copy = 'Copy ( Ctrl + C )';
  static const String paste = 'Paste ( Ctrl + V )';
  static const String undo = 'Undo ( Ctrl + Z )';
  static const String redo = 'Redo ( Ctrl + Y )';
  static const String delete = 'Delete';
  
  // Filter labels
  static const String exchangeFilter = 'Exchange';
  static const String symbolFilter = 'Symbol';
  static const String searchAndAdd = 'Search & Add';
  static const String selectAll = 'Select All';
  
  // Exchange types
  static const String nse = 'NSE';
  static const String mcx = 'MCX';
  static const String cePe = 'CE/PE';
  static const String others = 'OTHERS';
  static const String comex = 'COMEX';
  static const String crypto = 'CRYPTO';
  static const String gift = 'GIFT';
  static const String forex = 'FOREX';
  
  // Messages
  static const String noDataAvailable = 'No data available';
  static const String itemCopied = 'Item copied';
  static const String itemCut = 'Item cut';
  static const String itemPasted = 'Item pasted';
  static const String itemDeleted = 'Item deleted';
  static const String actionUndone = 'Action undone';
  static const String actionRedone = 'Action redone';
  static const String noItemsToPaste = 'No items to paste';
  static const String noActionsToUndo = 'No actions to undo';
  static const String noActionsToRedo = 'No actions to redo';
}
