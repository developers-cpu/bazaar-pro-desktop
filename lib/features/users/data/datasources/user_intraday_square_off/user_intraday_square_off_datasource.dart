import 'package:bazarpro/features/users/data/models/user_intraday_square_off/user_intraday_square_off_model.dart';

abstract class UserIntradaySquareOffDataSource {
  Future<List<UserIntradaySquareOffModel>> getUserIntradaySquareOff(
    String userId,
  );
}

class UserIntradaySquareOffDataSourceImpl
    implements UserIntradaySquareOffDataSource {
  static const List<String> _exchangeKeys = [
    'MCX',
    'NSE',
    'CE/PE',
    'OTHER',
    'COMEX',
    'FOREX',
    'USSTOCK',
    'GIFY',
    'CRYPTO',
  ];
  @override
  Future<List<UserIntradaySquareOffModel>> getUserIntradaySquareOff(
    String userId,
  ) async {
    return _exchangeKeys.asMap().entries.map((entry) {
      final index = entry.key;
      final exchange = entry.value;
      final isEnabled = exchange == 'NSE' || exchange == 'FOREX';
      final time = _getDefaultTime(exchange);
      return UserIntradaySquareOffModel(
        id: '${index + 1}',
        exchange: exchange,
        time: time,
        isEnabled: isEnabled,
      );
    }).toList();
  }

  String _getDefaultTime(String exchange) {
    switch (exchange) {
      case 'NSE':
        return '15:15';
      case 'MCX':
        return '23:15';
      case 'FOREX':
        return '16:00';
      case 'COMEX':
        return '23:30';
      default:
        return '15:30';
    }
  }
}