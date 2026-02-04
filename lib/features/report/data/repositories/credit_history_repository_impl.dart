import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/credit_history.dart';
import '../../domain/repositories/credit_history_repository.dart';
import '../datasources/credit_history/credit_history_remote_datasource.dart';
class CreditHistoryRepositoryImpl implements CreditHistoryRepository {
  final CreditHistoryRemoteDataSource remoteDataSource;
  CreditHistoryRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<CreditHistory>>> getCreditHistory({
    String? type,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getCreditHistory(
        type: type,
        search: search,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
