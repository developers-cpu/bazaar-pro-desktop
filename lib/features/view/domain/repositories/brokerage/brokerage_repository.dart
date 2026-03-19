import '../../entities/brokerage/brokerage.dart';

abstract class BrokerageRepository {
  Future<List<Brokerage>> getBrokerages({String? exchange});
}