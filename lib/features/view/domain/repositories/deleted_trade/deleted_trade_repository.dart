import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/deleted_trade/deleted_trade.dart';
abstract class DeletedTradeRepository {
  Future<Either<Failure, List<DeletedTrade>>> getDeletedTrades();
  Future<Either<Failure, List<DeletedTrade>>> getDeletedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  });
  Future<Either<Failure, List<String>>> getUserTypes();
  Future<Either<Failure, List<String>>> getUsers();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, String>> exportToPdf(List<DeletedTrade> trades);
  Future<Either<Failure, String>> exportToExcel(List<DeletedTrade> trades);
}
