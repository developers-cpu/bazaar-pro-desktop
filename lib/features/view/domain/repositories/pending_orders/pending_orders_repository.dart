import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/pending_orders/pending_order.dart';

abstract class PendingOrdersRepository {
  Future<Either<Failure, List<PendingOrder>>> getPendingOrders();
  Future<Either<Failure, List<PendingOrder>>> getPendingOrdersWithFilters({
    String? client,
    String? exchange,
    String? symbol,
    String? type,
  });
  Future<Either<Failure, List<String>>> getClients();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  List<String> getOrderTypes();
  Future<Either<Failure, String>> exportToPdf(List<PendingOrder> orders);
  Future<Either<Failure, String>> exportToExcel(List<PendingOrder> orders);
}