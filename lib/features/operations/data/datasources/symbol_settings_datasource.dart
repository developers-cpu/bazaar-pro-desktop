import '../../domain/entities/symbol_settings/symbol_setting.dart';

abstract class SymbolSettingsDatasource {
  List<SymbolSetting> getSymbolSettings({String? exchange});
}

class SymbolSettingsDatasourceImpl implements SymbolSettingsDatasource {
  static final List<SymbolSetting> _mockData = [
    const SymbolSetting(
      id: '1', index: 'NIFTY 50', exchange: 'NSE', symbol: 'NIFTY Oct 28',
      symbolTitle: 'NIFTY Oct 28',
      expiryDate: '28/10/2025', closeDate: '27/10/2025', cutDate: '26/10/2025', launchDate: '01/04/2025',
      description: 'NIFTY 50 Index Futures', lotSize: '50', tradeMarginPercent: '5.00',
      tradeMarginAmount: '42500', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.05', open: '24500.00', high: '24800.00', low: '24350.00',
    ),
    const SymbolSetting(
      id: '2', index: 'BANK NIFTY', exchange: 'NSE', symbol: 'BANKNIFTY Oct 28',
      symbolTitle: 'BANKNIFTY Oct 28',
      expiryDate: '28/10/2025', closeDate: '27/10/2025', cutDate: '26/10/2025', launchDate: '01/04/2025',
      description: 'Bank Nifty Index Futures', lotSize: '15', tradeMarginPercent: '6.00',
      tradeMarginAmount: '31500', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.05', open: '52000.00', high: '52800.00', low: '51600.00',
    ),
    const SymbolSetting(
      id: '3', index: 'NIFTY IT', exchange: 'NSE', symbol: 'NIFTYIT Nov 25',
      symbolTitle: 'NIFTYIT Nov 25',
      expiryDate: '25/11/2025', closeDate: '24/11/2025', cutDate: '23/11/2025', launchDate: '01/04/2025',
      description: 'Nifty IT Index Futures', lotSize: '40', tradeMarginPercent: '4.50',
      tradeMarginAmount: '21600', tradeAttribute: 'close', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: false,
      size: '0.10', open: '38200.00', high: '38900.00', low: '38050.00',
    ),
    const SymbolSetting(
      id: '4', index: 'GOLD', exchange: 'MCX', symbol: 'GOLD Dec 05',
      symbolTitle: 'GOLD Dec 05',
      expiryDate: '05/12/2025', closeDate: '04/12/2025', cutDate: '03/12/2025', launchDate: '01/07/2025',
      description: 'Gold Futures MCX', lotSize: '100', tradeMarginPercent: '3.50',
      tradeMarginAmount: '26250', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '1.00', open: '75000.00', high: '75800.00', low: '74600.00',
    ),
    const SymbolSetting(
      id: '5', index: 'SILVER', exchange: 'MCX', symbol: 'SILVER Dec 05',
      symbolTitle: 'SILVER Dec 05',
      expiryDate: '05/12/2025', closeDate: '04/12/2025', cutDate: '03/12/2025', launchDate: '01/07/2025',
      description: 'Silver Futures MCX', lotSize: '30', tradeMarginPercent: '4.00',
      tradeMarginAmount: '27000', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '1.00', open: '90000.00', high: '91500.00', low: '89500.00',
    ),
    const SymbolSetting(
      id: '6', index: 'CRUDEOIL', exchange: 'MCX', symbol: 'CRUDEOIL Nov 19',
      symbolTitle: 'CRUDEOIL Nov 19',
      expiryDate: '19/11/2025', closeDate: '18/11/2025', cutDate: '17/11/2025', launchDate: '01/05/2025',
      description: 'Crude Oil Futures MCX', lotSize: '100', tradeMarginPercent: '5.50',
      tradeMarginAmount: '41250', tradeAttribute: 'block', allowTrade: false,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: false,
      size: '1.00', open: '7500.00', high: '7680.00', low: '7420.00',
    ),
    const SymbolSetting(
      id: '7', index: 'GIFTNIFTY', exchange: 'GIFT', symbol: 'GIFTNIFTY Oct 28',
      symbolTitle: 'GIFTNIFTY Oct 28',
      expiryDate: '28/10/2025', closeDate: '27/10/2025', cutDate: '26/10/2025', launchDate: '01/04/2025',
      description: 'GIFT Nifty Futures', lotSize: '1', tradeMarginPercent: '6.00',
      tradeMarginAmount: '14760', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.50', open: '24600.00', high: '24880.00', low: '24440.00',
    ),
    const SymbolSetting(
      id: '8', index: 'CE NIFTY', exchange: 'CE/PE', symbol: 'NIFTY24800CE',
      symbolTitle: 'NIFTY24800CE',
      expiryDate: '28/10/2025', closeDate: '27/10/2025', cutDate: '26/10/2025', launchDate: '01/09/2025',
      description: 'NIFTY Call Option 24800 Strike', lotSize: '50', tradeMarginPercent: '2.00',
      tradeMarginAmount: '1000', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.05', open: '120.00', high: '185.00', low: '95.00',
    ),
    const SymbolSetting(
      id: '9', index: 'PE NIFTY', exchange: 'CE/PE', symbol: 'NIFTY24200PE',
      symbolTitle: 'NIFTY24200PE',
      expiryDate: '28/10/2025', closeDate: '27/10/2025', cutDate: '26/10/2025', launchDate: '01/09/2025',
      description: 'NIFTY Put Option 24200 Strike', lotSize: '50', tradeMarginPercent: '2.00',
      tradeMarginAmount: '800', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.05', open: '80.00', high: '140.00', low: '65.00',
    ),
    const SymbolSetting(
      id: '10', index: 'DOW JONES', exchange: 'COMEX', symbol: 'DOW Dec 19',
      symbolTitle: 'DOW Dec 19',
      expiryDate: '19/12/2025', closeDate: '18/12/2025', cutDate: '17/12/2025', launchDate: '01/06/2025',
      description: 'Dow Jones Industrial Index Futures', lotSize: '1', tradeMarginPercent: '3.00',
      tradeMarginAmount: '125400', tradeAttribute: 'close', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: false,
      size: '1.00', open: '41800.00', high: '42300.00', low: '41500.00',
    ),
    const SymbolSetting(
      id: '11', index: 'NASDAQ', exchange: 'COMEX', symbol: 'NASDAQ Dec 19',
      symbolTitle: 'NASDAQ Dec 19',
      expiryDate: '19/12/2025', closeDate: '18/12/2025', cutDate: '17/12/2025', launchDate: '01/06/2025',
      description: 'NASDAQ 100 Index Futures', lotSize: '1', tradeMarginPercent: '3.50',
      tradeMarginAmount: '64750', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.25', open: '18500.00', high: '18780.00', low: '18360.00',
    ),
    const SymbolSetting(
      id: '12', index: 'EURUSD', exchange: 'FOREX', symbol: 'EURUSD',
      symbolTitle: 'EURUSD',
      expiryDate: '31/12/2025', closeDate: '30/12/2025', cutDate: '29/12/2025', launchDate: '01/01/2025',
      description: 'Euro vs US Dollar', lotSize: '100000', tradeMarginPercent: '1.00',
      tradeMarginAmount: '1082', tradeAttribute: 'full', allowTrade: true,
      defaultInWatchlist: false, status: 'Open',
      autoTickSize: true,
      size: '0.00001', open: '1.0820', high: '1.0890', low: '1.0790',
    ),
  ];

  @override
  List<SymbolSetting> getSymbolSettings({String? exchange}) {
    if (exchange == null || exchange.isEmpty) return _mockData;
    return _mockData.where((s) => s.exchange == exchange).toList();
  }
}
