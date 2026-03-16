import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/settlement_master_sharing.dart';
abstract class SettlementMasterSharingRepository {
  Future<Either<Failure, SettlementMasterSharingData>> getMasterSharingData({
    String? masterId,
  });
  Future<Either<Failure, List<MasterUser>>> getAvailableMasters();
}
