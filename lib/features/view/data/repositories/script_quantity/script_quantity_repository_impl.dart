import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/script_quantity/script_quantity.dart';
import '../../../domain/repositories/script_quantity/script_quantity_repository.dart';
import '../../datasources/script_quantity/script_quantity_remote_datasource.dart';
class ScriptQuantityRepositoryImpl implements ScriptQuantityRepository {
  final ScriptQuantityRemoteDataSource remoteDataSource;
  ScriptQuantityRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<ScriptQuantity>>> getScriptQuantities({
    required String exchange,
    required String group,
  }) async {
    try {
      final quantities = await remoteDataSource.getScriptQuantities(
        exchange: exchange,
        group: group,
      );
      return Right(quantities);
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
  Future<Either<Failure, List<String>>> getGroups(String exchange) async {
    try {
      final groups = await remoteDataSource.getGroups(exchange);
      return Right(groups);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
