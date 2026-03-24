import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/expiry_report_model.dart';
import '../../domain/repositories/expiry_report_repository.dart';
import '../datasources/expiry_report/expiry_report_remote_datasource.dart';

class ExpiryReportRepositoryImpl implements ExpiryReportRepository {
  final ExpiryReportRemoteDataSource remoteDataSource;

  ExpiryReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExpiryReportModel>>> getExpiryReport({
    String? exchange,
  }) async {
    try {
      return await remoteDataSource.getExpiryReport(exchange: exchange);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }
}
