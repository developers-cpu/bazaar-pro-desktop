import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/bill_generate_report.dart';
import '../repositories/bill_generate_repository.dart';
class GetBillGenerateReport
    implements UseCase<BillGenerateReport, GetBillGenerateParams> {
  final BillGenerateRepository repository;
  GetBillGenerateReport(this.repository);
  @override
  Future<Either<Failure, BillGenerateReport>> call(
    GetBillGenerateParams params,
  ) async {
    return await repository.getBillGenerateReport(
      userId: params.userId,
      billFormat: params.billFormat,
      billType: params.billType,
    );
  }
}
class GetBillGenerateParams extends Equatable {
  final String userId;
  final String billFormat;
  final String billType;
  const GetBillGenerateParams({
    required this.userId,
    required this.billFormat,
    required this.billType,
  });
  @override
  List<Object?> get props => [userId, billFormat, billType];
}
