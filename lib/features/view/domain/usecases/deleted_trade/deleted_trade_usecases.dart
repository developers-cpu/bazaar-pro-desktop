import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/deleted_trade/deleted_trade.dart';
import '../../repositories/deleted_trade/deleted_trade_repository.dart';
class GetDeletedTrades implements UseCase<List<DeletedTrade>, NoParams> {
  final DeletedTradeRepository repository;
  GetDeletedTrades(this.repository);
  @override
  Future<Either<Failure, List<DeletedTrade>>> call(NoParams params) {
    return repository.getDeletedTrades();
  }
}
class GetDeletedTradesWithFilters
    implements UseCase<List<DeletedTrade>, DeletedTradeFilterParams> {
  final DeletedTradeRepository repository;
  GetDeletedTradesWithFilters(this.repository);
  @override
  Future<Either<Failure, List<DeletedTrade>>> call(
    DeletedTradeFilterParams params,
  ) {
    return repository.getDeletedTradesWithFilters(
      userType: params.userType,
      user: params.user,
      exchange: params.exchange,
      symbol: params.symbol,
    );
  }
}
class DeletedTradeFilterParams {
  final String? userType;
  final String? user;
  final String? exchange;
  final String? symbol;
  const DeletedTradeFilterParams({
    this.userType,
    this.user,
    this.exchange,
    this.symbol,
  });
}
class GetDeletedTradeUserTypes implements UseCase<List<String>, NoParams> {
  final DeletedTradeRepository repository;
  GetDeletedTradeUserTypes(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getUserTypes();
  }
}
class GetDeletedTradeUsers implements UseCase<List<String>, NoParams> {
  final DeletedTradeRepository repository;
  GetDeletedTradeUsers(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getUsers();
  }
}
class GetDeletedTradeExchanges implements UseCase<List<String>, NoParams> {
  final DeletedTradeRepository repository;
  GetDeletedTradeExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}
class GetDeletedTradeSymbols implements UseCase<List<String>, NoParams> {
  final DeletedTradeRepository repository;
  GetDeletedTradeSymbols(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}
class ExportDeletedTradesToPdf implements UseCase<String, List<DeletedTrade>> {
  final DeletedTradeRepository repository;
  ExportDeletedTradesToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<DeletedTrade> trades) {
    return repository.exportToPdf(trades);
  }
}
class ExportDeletedTradesToExcel
    implements UseCase<String, List<DeletedTrade>> {
  final DeletedTradeRepository repository;
  ExportDeletedTradesToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<DeletedTrade> trades) {
    return repository.exportToExcel(trades);
  }
}
