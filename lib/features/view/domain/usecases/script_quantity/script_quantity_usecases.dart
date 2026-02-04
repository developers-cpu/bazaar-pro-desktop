import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/script_quantity/script_quantity.dart';
import '../../repositories/script_quantity/script_quantity_repository.dart';
class GetScriptQuantities implements UseCase<List<ScriptQuantity>, ScriptQuantityParams> {
  final ScriptQuantityRepository repository;
  GetScriptQuantities(this.repository);
  @override
  Future<Either<Failure, List<ScriptQuantity>>> call(ScriptQuantityParams params) {
    return repository.getScriptQuantities(
      exchange: params.exchange,
      group: params.group,
    );
  }
}
class ScriptQuantityParams {
  final String exchange;
  final String group;
  const ScriptQuantityParams({
    required this.exchange,
    required this.group,
  });
}
class GetScriptQuantityExchanges implements UseCase<List<String>, NoParams> {
  final ScriptQuantityRepository repository;
  GetScriptQuantityExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}
class GetScriptQuantityGroups implements UseCase<List<String>, String> {
  final ScriptQuantityRepository repository;
  GetScriptQuantityGroups(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(String exchange) {
    return repository.getGroups(exchange);
  }
}
