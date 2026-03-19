import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/settlement_master_sharing.dart';
import '../../domain/repositories/settlement_master_sharing_repository.dart';
import '../datasources/settlement_master_sharing_datasource.dart';

class SettlementMasterSharingRepositoryImpl
    implements SettlementMasterSharingRepository {
  final SettlementMasterSharingDataSource dataSource;
  SettlementMasterSharingRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, SettlementMasterSharingData>> getMasterSharingData({
    String? masterId,
  }) async {
    try {
      final data = await dataSource.getMasterSharingData(masterId: masterId);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MasterUser>>> getAvailableMasters() async {
    try {
      final masters = await dataSource.getAvailableMasters();
      return Right(masters);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}