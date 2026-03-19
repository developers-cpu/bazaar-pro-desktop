import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/bill_generate_report.dart';

abstract class BillGenerateRepository {
  Future<Either<Failure, BillGenerateReport>> getBillGenerateReport({
    required String userId,
    required String billFormat,
    required String billType,
  });
}