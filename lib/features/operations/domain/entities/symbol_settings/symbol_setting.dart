class SymbolSetting {
  final String id;
  final String index;
  final String exchange;
  final String symbol;
  final String symbolTitle;
  final String expiryDate;
  final String closeDate;
  final String cutDate;
  final String launchDate;
  final String description;
  final String lotSize;
  final String tradeMarginPercent;
  final String tradeMarginAmount;
  final String tradeAttribute;
  final bool allowTrade;
  final bool defaultInWatchlist;
  final String status;
  final bool autoTickSize;
  final String size;
  final String open;
  final String high;
  final String low;
  final String marginType;
  final String intradayMarginPercent;
  final String carryForwardMarginPercent;
  final String intradayMarginAmount;
  final String carryForwardMarginAmount;

  const SymbolSetting({
    required this.id,
    required this.index,
    required this.exchange,
    required this.symbol,
    required this.symbolTitle,
    required this.expiryDate,
    required this.closeDate,
    required this.cutDate,
    required this.launchDate,
    required this.description,
    required this.lotSize,
    required this.tradeMarginPercent,
    required this.tradeMarginAmount,
    required this.tradeAttribute,
    required this.allowTrade,
    required this.defaultInWatchlist,
    required this.status,
    required this.autoTickSize,
    required this.size,
    required this.open,
    required this.high,
    required this.low,
    this.marginType = 'Percentage',
    this.intradayMarginPercent = '0.00',
    this.carryForwardMarginPercent = '0.00',
    this.intradayMarginAmount = '0',
    this.carryForwardMarginAmount = '0',
  });

  SymbolSetting copyWith({
    String? id,
    String? index,
    String? exchange,
    String? symbol,
    String? symbolTitle,
    String? expiryDate,
    String? closeDate,
    String? cutDate,
    String? launchDate,
    String? description,
    String? lotSize,
    String? tradeMarginPercent,
    String? tradeMarginAmount,
    String? tradeAttribute,
    bool? allowTrade,
    bool? defaultInWatchlist,
    String? status,
    bool? autoTickSize,
    String? size,
    String? open,
    String? high,
    String? low,
    String? marginType,
    String? intradayMarginPercent,
    String? carryForwardMarginPercent,
    String? intradayMarginAmount,
    String? carryForwardMarginAmount,
  }) {
    return SymbolSetting(
      id: id ?? this.id,
      index: index ?? this.index,
      exchange: exchange ?? this.exchange,
      symbol: symbol ?? this.symbol,
      symbolTitle: symbolTitle ?? this.symbolTitle,
      expiryDate: expiryDate ?? this.expiryDate,
      closeDate: closeDate ?? this.closeDate,
      cutDate: cutDate ?? this.cutDate,
      launchDate: launchDate ?? this.launchDate,
      description: description ?? this.description,
      lotSize: lotSize ?? this.lotSize,
      tradeMarginPercent: tradeMarginPercent ?? this.tradeMarginPercent,
      tradeMarginAmount: tradeMarginAmount ?? this.tradeMarginAmount,
      tradeAttribute: tradeAttribute ?? this.tradeAttribute,
      allowTrade: allowTrade ?? this.allowTrade,
      defaultInWatchlist: defaultInWatchlist ?? this.defaultInWatchlist,
      status: status ?? this.status,
      autoTickSize: autoTickSize ?? this.autoTickSize,
      size: size ?? this.size,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      marginType: marginType ?? this.marginType,
      intradayMarginPercent:
          intradayMarginPercent ?? this.intradayMarginPercent,
      carryForwardMarginPercent:
          carryForwardMarginPercent ?? this.carryForwardMarginPercent,
      intradayMarginAmount: intradayMarginAmount ?? this.intradayMarginAmount,
      carryForwardMarginAmount:
          carryForwardMarginAmount ?? this.carryForwardMarginAmount,
    );
  }
}


  