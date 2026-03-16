import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../domain/repositories/pending_orders/pending_orders_repository.dart';
import '../../datasources/pending_order/pending_orders_remote_datasource.dart';
class PendingOrdersRepositoryImpl implements PendingOrdersRepository {
  final PendingOrdersRemoteDataSource remoteDataSource;
  PendingOrdersRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<PendingOrder>>> getPendingOrders() async {
    try {
      final orders = await remoteDataSource.getPendingOrders();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<PendingOrder>>> getPendingOrdersWithFilters({
    String? client,
    String? exchange,
    String? symbol,
    String? type,
  }) async {
    try {
      final orders = await remoteDataSource.getPendingOrdersWithFilters(
        client: client,
        exchange: exchange,
        symbol: symbol,
        type: type,
      );
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getClients() async {
    try {
      final clients = await remoteDataSource.getClients();
      return Right(clients);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getExchanges() async {
    try {
      final exchanges = await remoteDataSource.getExchanges();
      return Right(exchanges);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getSymbols() async {
    try {
      final symbols = await remoteDataSource.getSymbols();
      return Right(symbols);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  List<String> getOrderTypes() {
    return [
      'All',
      'Buy',
      'Sell',
      'Buy Limit',
      'Buy Stop',
      'Sell Limit',
      'Sell Stop',
    ];
  }
  @override
  Future<Either<Failure, String>> exportToPdf(List<PendingOrder> orders) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final filePath =
          '/downloads/pending_orders_${DateTime.now().millisecondsSinceEpoch}.pdf';
      return Right(filePath);
    } catch (e) {
      return Left(ExportFailure('Failed to export PDF: $e'));
    }
  }
  @override
  Future<Either<Failure, String>> exportToExcel(
    List<PendingOrder> orders,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final filePath =
          '/downloads/pending_orders_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      return Right(filePath);
    } catch (e) {
      return Left(ExportFailure('Failed to export Excel: $e'));
    }
  }
}
