import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/spraed_report_entity.dart';
import '../../domain/repositories/spraed_report_repository.dart';
import '../datasources/spraed_report/spraed_report_remote_datasource.dart';

class SpraedReportRepositoryImpl implements SpraedReportRepository {
  final SpraedReportRemoteDataSource remoteDataSource;

  SpraedReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SpraedReportEntity>>> getSpraedReport({String? exchange}) async {
    try {
      final remoteData = await remoteDataSource.getSpraedReport(exchange: exchange);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
