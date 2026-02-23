import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/bill_generate_report.dart';
import '../../domain/repositories/bill_generate_repository.dart';
import '../datasources/bill_generate_remote_datasource.dart';
class BillGenerateRepositoryImpl implements BillGenerateRepository {
  final BillGenerateRemoteDataSource remoteDataSource;
  BillGenerateRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, BillGenerateReport>> getBillGenerateReport({
    required String userId,
    required String billFormat,
    required String billType,
  }) async {
    try {
      final report = await remoteDataSource.getBillGenerateReport(
        userId: userId,
        billFormat: billFormat,
        billType: billType,
      );
      return Right(report);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
