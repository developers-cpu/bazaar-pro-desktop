import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/settlement_report.dart';
import '../repositories/settlement_report_repository.dart';

class GetSettlementReport
    implements UseCase<SettlementReport, GetSettlementReportParams> {
  final SettlementReportRepository repository;
  GetSettlementReport(this.repository);
  @override
  Future<Either<Failure, SettlementReport>> call(
    GetSettlementReportParams params,
  ) async {
    return await repository.getSettlementReport(
      dateRange: params.dateRange,
      userId: params.userId,
    );
  }
}

class GetSettlementReportParams extends Equatable {
  final String dateRange;
  final String? userId;
  const GetSettlementReportParams({required this.dateRange, this.userId});
  @override
  List<Object?> get props => [dateRange, userId];
}
