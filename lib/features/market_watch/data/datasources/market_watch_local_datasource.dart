import '../../../../core/errors/exceptions.dart';
import '../models/market_item_model.dart';




abstract class MarketWatchLocalDataSource {
  
  Future<List<MarketItemModel>> getMarketItems();
  
  
  Future<MarketItemModel> addMarketItem(MarketItemModel item);
  
  
  Future<bool> deleteMarketItem(String id);
  
  
  Future<MarketItemModel> updateMarketItem(MarketItemModel item);
}


class MarketWatchLocalDataSourceImpl implements MarketWatchLocalDataSource {
  
  final List<MarketItemModel> _marketItems = _getDummyData();

  @override
  Future<List<MarketItemModel>> getMarketItems() async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 300));
      return List.from(_marketItems);
    } catch (e) {
      throw CacheException('Failed to get market items from cache');
    }
  }

  @override
  Future<MarketItemModel> addMarketItem(MarketItemModel item) async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 200));
      _marketItems.add(item);
      return item;
    } catch (e) {
      throw CacheException('Failed to add market item to cache');
    }
  }

  @override
  Future<bool> deleteMarketItem(String id) async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 200));
      final index = _marketItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _marketItems.removeAt(index);
        return true;
      }
      return false;
    } catch (e) {
      throw CacheException('Failed to delete market item from cache');
    }
  }

  @override
  Future<MarketItemModel> updateMarketItem(MarketItemModel item) async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 200));
      final index = _marketItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _marketItems[index] = item;
        return item;
      }
      throw NoDataException('Market item not found');
    } catch (e) {
      if (e is NoDataException) rethrow;
      throw CacheException('Failed to update market item in cache');
    }
  }

  
  
  static List<MarketItemModel> _getDummyData() {
    final now = DateTime.now();
    
    return [
      MarketItemModel(
        id: '1',
        exchange: 'MCX',
        symbol: 'SILVER',
        buyQty: 1,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 5,
        netChange: 0.87,
        high: 155843,
        low: 154984,
        open: 15598,
        close: 15468,
        ltp: 10000,
        netChangePercent: 0.37,
        expiry: DateTime(2025, 12, 5),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '2',
        exchange: 'NSE',
        symbol: 'NIFTY',
        buyQty: 675,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 60,
        netChange: -0.43,
        high: 15149,
        low: 15247,
        open: 15657,
        close: 156264,
        ltp: 2588212,
        netChangePercent: 0.37,
        expiry: DateTime(2025, 11, 25),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '3',
        exchange: 'MCX',
        symbol: 'GOLD',
        buyQty: 1,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 1,
        netChange: -0.27,
        high: 2051,
        low: 2036,
        open: 2036,
        close: 2051,
        ltp: 25957,
        netChangePercent: 0.37,
        expiry: DateTime(2025, 12, 5),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '4',
        exchange: 'NSE',
        symbol: 'DALBHARAT',
        buyQty: 65,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 65,
        netChange: -0.98,
        high: 124444,
        low: 123841,
        open: 124300,
        close: 124913,
        ltp: 123971,
        netChangePercent: -0.08,
        expiry: DateTime(2025, 11, 25),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '5',
        exchange: 'OTHER',
        symbol: 'DOW',
        buyQty: 2,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 2,
        netChange: 58,
        high: 2076,
        low: 2030,
        open: 2036,
        close: 2051,
        ltp: 2038,
        netChangePercent: 0.37,
        expiry: DateTime(2025, 11, 25),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '6',
        exchange: 'OTHER',
        symbol: 'NASDAQ',
        buyQty: 2,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 1,
        netChange: -12.13,
        high: 27555,
        low: 27432,
        open: 27500,
        close: 27385,
        ltp: 2588212,
        netChangePercent: 0.37,
        expiry: DateTime(2025, 11, 25),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '7',
        exchange: 'OTHER',
        symbol: 'S & P',
        buyQty: 1,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 1,
        netChange: 64.3,
        high: 58650,
        low: 58462,
        open: 58606,
        close: 58370,
        ltp: 58548,
        netChangePercent: 0.37,
        expiry: DateTime(2025, 12, 5),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '8',
        exchange: 'CRYPTO',
        symbol: 'ETHUSD',
        buyQty: 5,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 3,
        netChange: -23.5,
        high: 1150,
        low: 1246,
        open: 1454,
        close: 1571,
        ltp: 2588212,
        netChangePercent: -0.08,
        expiry: DateTime(2025, 11, 25),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '9',
        exchange: 'MCX',
        symbol: 'GOLD',
        buyQty: 0,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 0,
        netChange: 178,
        high: 25978,
        low: 25897,
        open: 25960,
        close: 25974,
        ltp: 25950,
        netChangePercent: -0.08,
        expiry: DateTime(2025, 11, 28),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
      MarketItemModel(
        id: '10',
        exchange: 'GIFT',
        symbol: 'GIFTNIFTY',
        buyQty: 100,
        buyPrice: 2588212,
        sellPrice: 2588212,
        sellQty: 50,
        netChange: 25.5,
        high: 15200,
        low: 15100,
        open: 15150,
        close: 15180,
        ltp: 15175,
        netChangePercent: 0.17,
        expiry: DateTime(2025, 10, 28),
        lut: DateTime(2025, 11, 12, 10, 36, 55),
      ),
    ];
  }
}
