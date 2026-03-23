import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/rule_entity.dart';
import '../../domain/repositories/rules_repository.dart';
import '../datasources/rules_remote_datasource.dart';

class RulesRepositoryImpl implements RulesRepository {
  final RulesRemoteDataSource remoteDataSource;
  RulesRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<RuleEntity>>> getRules() async {
    try {
      final rules = await remoteDataSource.getRules();
      return Right(rules);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
