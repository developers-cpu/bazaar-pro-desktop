import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/deals/deals.dart';
import '../../../domain/repositories/deals/deals_repository.dart';
import '../../datasources/deals/deals_remote_datasource.dart';
import '../../models/deals/deals_model.dart';
class DealsRepositoryImpl implements DealsRepository {
  final DealsRemoteDataSource remoteDataSource;
  DealsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<Deal>>> getDeals() async {
    try {
      final deals = await remoteDataSource.getDeals();
      return Right(deals);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<Deal>>> getDealsWithFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? client,
    String? exchange,
    String? symbol,
    String? orderType,
    String? status,
  }) async {
    try {
      final deals = await remoteDataSource.getDealsWithFilters(
        startDate: startDate,
        endDate: endDate,
        client: client,
        exchange: exchange,
        symbol: symbol,
        orderType: orderType,
        status: status,
      );
      return Right(deals);
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
  Future<Either<Failure, List<String>>> getOrderTypes() async {
    try {
      final orderTypes = await remoteDataSource.getOrderTypes();
      return Right(orderTypes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getStatuses() async {
    try {
      final statuses = await remoteDataSource.getStatuses();
      return Right(statuses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, String>> exportToPdf(List<Deal> deals) async {
    try {
      final models = deals.map((d) => DealModel.fromEntity(d)).toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, String>> exportToExcel(List<Deal> deals) async {
    try {
      final models = deals.map((d) => DealModel.fromEntity(d)).toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
