import 'package:bazarpro/features/view/domain/entities/brokerage/brokerage.dart';
import 'package:bazarpro/features/view/domain/repositories/brokerage/brokerage_repository.dart';
import 'package:bazarpro/features/view/data/datasources/brokerage/brokerage_remote_datasource.dart';

class BrokerageRepositoryImpl implements BrokerageRepository {
  final BrokerageRemoteDataSource dataSource;
  BrokerageRepositoryImpl({required this.dataSource});
  @override
  Future<List<Brokerage>> getBrokerages({String? exchange}) async {
    final models = await dataSource.getBrokerages(exchange: exchange);
    return models
        .map(
          (m) => Brokerage(
            exchange: m.exchange,
            symbol: m.symbol,
            brokeragePercentage: m.brokeragePercentage,
            brokerageAmount: m.brokerageAmount,
          ),
        )
        .toList();
  }
}