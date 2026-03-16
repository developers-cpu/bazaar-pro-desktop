import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/rule_entity.dart';
import '../repositories/rules_repository.dart';

class GetRulesUseCase implements UseCase<List<RuleEntity>, NoParams> {
  final RulesRepository repository;
  GetRulesUseCase({required this.repository});
  @override
  Future<Either<Failure, List<RuleEntity>>> call(NoParams params) async {
    return await repository.getRules();
  }
}
