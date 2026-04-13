import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/ban_script_entity.dart';
import '../../domain/repositories/ban_script_repository.dart';
import '../datasources/ban_script/ban_script_remote_datasource.dart';

class BanScriptRepositoryImpl implements BanScriptRepository {
  final BanScriptRemoteDataSource remoteDataSource;

  BanScriptRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BanScriptEntity>>> getBanScripts({String? exchange, String? banType}) async {
    try {
      final remoteData = await remoteDataSource.getBanScripts(exchange: exchange, banType: banType);
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
