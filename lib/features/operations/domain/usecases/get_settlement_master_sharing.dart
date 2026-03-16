import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settlement_master_sharing.dart';
import '../repositories/settlement_master_sharing_repository.dart';
class GetSettlementMasterSharing
    implements
        UseCase<SettlementMasterSharingData, GetSettlementMasterSharingParams> {
  final SettlementMasterSharingRepository repository;
  GetSettlementMasterSharing(this.repository);
  @override
  Future<Either<Failure, SettlementMasterSharingData>> call(
    GetSettlementMasterSharingParams params,
  ) async {
    return await repository.getMasterSharingData(masterId: params.masterId);
  }
}
class GetSettlementMasterSharingParams extends Equatable {
  final String? masterId;
  const GetSettlementMasterSharingParams({this.masterId});
  @override
  List<Object?> get props => [masterId];
}
