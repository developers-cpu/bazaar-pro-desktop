import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rule_entity.dart';
abstract class RulesRepository {
  Future<Either<Failure, List<RuleEntity>>> getRules();
}
