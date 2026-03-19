import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/deals/deals.dart';

abstract class DealsRepository {
  Future<Either<Failure, List<Deal>>> getDeals();
  Future<Either<Failure, List<Deal>>> getDealsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
    String? status,
  });
  Future<Either<Failure, List<String>>> getClients();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, List<String>>> getOrderTypes();
  Future<Either<Failure, List<String>>> getStatuses();
  Future<Either<Failure, String>> exportToPdf(List<Deal> deals);
  Future<Either<Failure, String>> exportToExcel(List<Deal> deals);
}