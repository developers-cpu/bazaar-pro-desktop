import '../models/market_timing_model.dart';
abstract class MarketTimingRemoteDataSource {
  Future<MarketTimingModel> getMarketTiming(String exchange, DateTime date);
}
class MarketTimingRemoteDataSourceImpl implements MarketTimingRemoteDataSource {
  @override
  Future<MarketTimingModel> getMarketTiming(
    String exchange,
    DateTime date,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final isWeekend =
        date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;
    if (isWeekend) {
      return const MarketTimingModel(
        status: 'WEEKEND',
        isOpen: false,
        timings: [],
      );
    }
    List<TimingSlotModel> timings = [];
    if (exchange == 'NSE') {
      timings = [const TimingSlotModel(start: '09:15 AM', end: '03:30 PM')];
    } else if (exchange == 'MCX') {
      timings = [const TimingSlotModel(start: '09:00 AM', end: '11:30 PM')];
    } else if (exchange == 'CRYPTO') {
      timings = [const TimingSlotModel(start: '12:00 AM', end: '11:59 PM')];
    } else {
      timings = [const TimingSlotModel(start: '09:00 AM', end: '05:00 PM')];
    }
    return MarketTimingModel(
      status: 'MARKET OPEN',
      isOpen: true,
      timings: timings,
    );
  }
}
