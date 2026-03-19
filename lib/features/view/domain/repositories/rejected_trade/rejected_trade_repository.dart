import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/rejected_trade/rejected_trade.dart';

abstract class RejectedTradeRepository {
  Future<Either<Failure, List<RejectedTrade>>> getRejectedTrades();
  Future<Either<Failure, List<RejectedTrade>>> getRejectedTradesWithFilters({
    String? userType,
    String? user,
    String? exchange,
    String? symbol,
  });
  Future<Either<Failure, List<String>>> getUserTypes();
  Future<Either<Failure, List<String>>> getUsers();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, String>> exportToPdf(List<RejectedTrade> trades);
  Future<Either<Failure, String>> exportToExcel(List<RejectedTrade> trades);
}