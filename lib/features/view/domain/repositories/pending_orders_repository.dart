import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pending_order.dart';

/// Abstract repository for Pending Orders
abstract class PendingOrdersRepository {
  /// Get all pending orders
  Future<Either<Failure, List<PendingOrder>>> getPendingOrders();

  /// Get pending orders with filters
  Future<Either<Failure, List<PendingOrder>>> getPendingOrdersWithFilters({
    String? client,
    String? exchange,
    String? symbol,
    String? type,
  });

  /// Get available clients for filter dropdown
  Future<Either<Failure, List<String>>> getClients();

  /// Get available exchanges for filter dropdown
  Future<Either<Failure, List<String>>> getExchanges();

  /// Get available symbols for filter dropdown
  Future<Either<Failure, List<String>>> getSymbols();

  /// Get order types for filter dropdown
  List<String> getOrderTypes();

  /// Export orders to PDF
  Future<Either<Failure, String>> exportToPdf(List<PendingOrder> orders);

  /// Export orders to Excel
  Future<Either<Failure, String>> exportToExcel(List<PendingOrder> orders);
}