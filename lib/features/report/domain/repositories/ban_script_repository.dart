import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/ban_script_entity.dart';

abstract class BanScriptRepository {
  Future<Either<Failure, List<BanScriptEntity>>> getBanScripts({String? exchange, String? banType});
}
