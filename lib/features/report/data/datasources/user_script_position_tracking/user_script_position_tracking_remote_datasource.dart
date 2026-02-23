import '../../models/user_script_position_tracking_model.dart';

abstract class UserScriptPositionTrackingRemoteDataSource {
  Future<List<UserScriptPositionTrackingModel>> getUserScriptPositionTracking({
    String? startDate,
    String? endDate,
    String? userId,
    String? exchange,
    String? symbol,
  });
}

class UserScriptPositionTrackingRemoteDataSourceImpl
    implements UserScriptPositionTrackingRemoteDataSource {
  @override
  Future<List<UserScriptPositionTrackingModel>> getUserScriptPositionTracking({
    String? startDate,
    String? endDate,
    String? userId,
    String? exchange,
    String? symbol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<UserScriptPositionTrackingModel> mockData = [
      const UserScriptPositionTrackingModel(
        id: '1',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'GOLD05DEC',
        position: 'BUY',
        openAPrice: 97457,
        days: 137,
      ),
      const UserScriptPositionTrackingModel(
        id: '2',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'DEMO4',
        symbol: 'CRUDEOIL',
        position: 'BUY',
        openAPrice: 5798,
        days: 145,
      ),
      const UserScriptPositionTrackingModel(
        id: '3',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'NIFTY',
        position: 'BUY',
        openAPrice: 24850,
        days: 131,
      ),
      const UserScriptPositionTrackingModel(
        id: '4',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'DEMO4',
        symbol: 'BANKNIFTY',
        position: 'BUY',
        openAPrice: 56415,
        days: 145,
      ),
      const UserScriptPositionTrackingModel(
        id: '5',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'CANBK',
        position: 'BUY',
        openAPrice: 110,
        days: 131,
      ),
      const UserScriptPositionTrackingModel(
        id: '6',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'IRCTC',
        position: 'BUY',
        openAPrice: 2181,
        days: 124,
      ),
      const UserScriptPositionTrackingModel(
        id: '7',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'DEMO4',
        symbol: 'BANKNIFTY25JUL25',
        position: 'BUY',
        openAPrice: 745,
        days: 137,
      ),
      const UserScriptPositionTrackingModel(
        id: '8',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'SILVER',
        position: 'BUY',
        openAPrice: 6,
        days: 96,
      ),
      const UserScriptPositionTrackingModel(
        id: '9',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'GOLDM',
        position: 'BUY',
        openAPrice: 8,
        days: 145,
      ),
      const UserScriptPositionTrackingModel(
        id: '10',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'PATIL',
        symbol: 'GOLD05DEC',
        position: 'BUY',
        openAPrice: 110258,
        days: 103,
      ),
      const UserScriptPositionTrackingModel(
        id: '11',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'DEMO4',
        symbol: 'BTCUSD',
        position: 'BUY',
        openAPrice: 97842,
        days: 145,
      ),
      const UserScriptPositionTrackingModel(
        id: '12',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'DEMO4',
        symbol: 'GOLD05DEC',
        position: 'BUY',
        openAPrice: 2747,
        days: 145,
      ),
      const UserScriptPositionTrackingModel(
        id: '13',
        positionDate: '11/07/25 04:01:55 PM',
        userName: 'DEMO4',
        symbol: 'DOWJONES19SEP25',
        position: 'BUY',
        openAPrice: 45399,
        days: 103,
      ),
    ];
    List<UserScriptPositionTrackingModel> filteredData = mockData;
    if (userId != null && userId.isNotEmpty) {
      filteredData = filteredData
          .where((item) => item.userName.toLowerCase() == userId.toLowerCase())
          .toList();
    }
    if (symbol != null && symbol.isNotEmpty) {
      filteredData = filteredData
          .where(
            (item) => item.symbol.toLowerCase().contains(symbol.toLowerCase()),
          )
          .toList();
    }
    return filteredData;
  }
}
