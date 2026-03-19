import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/rejected_trade/rejected_trade.dart';
import '../../repositories/rejected_trade/rejected_trade_repository.dart';

class GetRejectedTrades implements UseCase<List<RejectedTrade>, NoParams> {
  final RejectedTradeRepository repository;
  GetRejectedTrades(this.repository);
  @override
  Future<Either<Failure, List<RejectedTrade>>> call(NoParams params) {
    return repository.getRejectedTrades();
  }
}

class GetRejectedTradesWithFilters
    implements UseCase<List<RejectedTrade>, RejectedTradeFilterParams> {
  final RejectedTradeRepository repository;
  GetRejectedTradesWithFilters(this.repository);
  @override
  Future<Either<Failure, List<RejectedTrade>>> call(
    RejectedTradeFilterParams params,
  ) {
    return repository.getRejectedTradesWithFilters(
      userType: params.userType,
      user: params.user,
      exchange: params.exchange,
      symbol: params.symbol,
    );
  }
}

class RejectedTradeFilterParams {
  final String? userType;
  final String? user;
  final String? exchange;
  final String? symbol;
  const RejectedTradeFilterParams({
    this.userType,
    this.user,
    this.exchange,
    this.symbol,
  });
}

class GetRejectedTradeUserTypes implements UseCase<List<String>, NoParams> {
  final RejectedTradeRepository repository;
  GetRejectedTradeUserTypes(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getUserTypes();
  }
}

class GetRejectedTradeUsers implements UseCase<List<String>, NoParams> {
  final RejectedTradeRepository repository;
  GetRejectedTradeUsers(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getUsers();
  }
}

class GetRejectedTradeExchanges implements UseCase<List<String>, NoParams> {
  final RejectedTradeRepository repository;
  GetRejectedTradeExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}

class GetRejectedTradeSymbols implements UseCase<List<String>, NoParams> {
  final RejectedTradeRepository repository;
  GetRejectedTradeSymbols(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}

class ExportRejectedTradesToPdf
    implements UseCase<String, List<RejectedTrade>> {
  final RejectedTradeRepository repository;
  ExportRejectedTradesToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<RejectedTrade> trades) {
    return repository.exportToPdf(trades);
  }
}

class ExportRejectedTradesToExcel
    implements UseCase<String, List<RejectedTrade>> {
  final RejectedTradeRepository repository;
  ExportRejectedTradesToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<RejectedTrade> trades) {
    return repository.exportToExcel(trades);
  }
}