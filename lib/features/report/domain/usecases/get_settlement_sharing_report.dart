import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/settlement_sharing_report.dart';
import '../repositories/settlement_sharing_report_repository.dart';

class GetSettlementSharingReport
    implements
        UseCase<SettlementSharingReport, GetSettlementSharingReportParams> {
  final SettlementSharingReportRepository repository;
  GetSettlementSharingReport(this.repository);
  @override
  Future<Either<Failure, SettlementSharingReport>> call(
    GetSettlementSharingReportParams params,
  ) async {
    return await repository.getSettlementSharingReport(
      dateRange: params.dateRange,
      userId: params.userId,
    );
  }
}

class GetSettlementSharingReportParams extends Equatable {
  final String dateRange;
  final String? userId;
  const GetSettlementSharingReportParams({
    required this.dateRange,
    this.userId,
  });
  @override
  List<Object?> get props => [dateRange, userId];
}