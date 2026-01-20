import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/trades/trade.dart';
import '../../repositories/trades/trades_repository.dart';

/// Get all trades usecase
class GetTrades implements UseCase<List<Trade>, NoParams> {
  final TradesRepository repository;

  GetTrades(this.repository);

  @override
  Future<Either<Failure, List<Trade>>> call(NoParams params) {
    return repository.getTrades();
  }
}

/// Get trades with filters usecase
class GetTradesWithFilters implements UseCase<List<Trade>, TradesFilterParams> {
  final TradesRepository repository;

  GetTradesWithFilters(this.repository);

  @override
  Future<Either<Failure, List<Trade>>> call(TradesFilterParams params) {
    return repository.getTradesWithFilters(
      startDate: params.startDate,
      endDate: params.endDate,
      client: params.client,
      exchange: params.exchange,
      symbol: params.symbol,
      orderType: params.orderType,
    );
  }
}

/// Filter parameters for trades
class TradesFilterParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? client;
  final String? exchange;
  final String? symbol;
  final String? orderType;

  const TradesFilterParams({
    this.startDate,
    this.endDate,
    this.client,
    this.exchange,
    this.symbol,
    this.orderType,
  });
}

/// Get clients for filter
class GetTradesClients implements UseCase<List<String>, NoParams> {
  final TradesRepository repository;

  GetTradesClients(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getClients();
  }
}

/// Get exchanges for filter
class GetTradesExchanges implements UseCase<List<String>, NoParams> {
  final TradesRepository repository;

  GetTradesExchanges(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}

/// Get symbols for filter
class GetTradesSymbols implements UseCase<List<String>, NoParams> {
  final TradesRepository repository;

  GetTradesSymbols(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}

/// Get order types for filter
class GetTradesOrderTypes implements UseCase<List<String>, NoParams> {
  final TradesRepository repository;

  GetTradesOrderTypes(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getOrderTypes();
  }
}

/// Export trades to PDF
class ExportTradesToPdf implements UseCase<String, List<Trade>> {
  final TradesRepository repository;

  ExportTradesToPdf(this.repository);

  @override
  Future<Either<Failure, String>> call(List<Trade> trades) {
    return repository.exportToPdf(trades);
  }
}

/// Export trades to Excel
class ExportTradesToExcel implements UseCase<String, List<Trade>> {
  final TradesRepository repository;

  ExportTradesToExcel(this.repository);

  @override
  Future<Either<Failure, String>> call(List<Trade> trades) {
    return repository.exportToExcel(trades);
  }
}