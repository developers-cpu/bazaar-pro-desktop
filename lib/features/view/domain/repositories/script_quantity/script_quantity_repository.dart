import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/script_quantity/script_quantity.dart';

abstract class ScriptQuantityRepository {
  Future<Either<Failure, List<ScriptQuantity>>> getScriptQuantities({
    required String exchange,
    required String group,
  });
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getGroups(String exchange);
}