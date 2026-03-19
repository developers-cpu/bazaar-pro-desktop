import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/trades/trade.dart';

abstract class TradesRepository {
  Future<Either<Failure, List<Trade>>> getTrades();
  Future<Either<Failure, List<Trade>>> getTradesWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
  });
  Future<Either<Failure, List<String>>> getClients();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, List<String>>> getOrderTypes();
  Future<Either<Failure, String>> exportToPdf(List<Trade> trades);
  Future<Either<Failure, String>> exportToExcel(List<Trade> trades);
}