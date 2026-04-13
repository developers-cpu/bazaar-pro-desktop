import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/ban_script_entity.dart';
import '../repositories/ban_script_repository.dart';

class GetBanScriptUseCase implements UseCase<List<BanScriptEntity>, BanScriptParams> {
  final BanScriptRepository repository;

  GetBanScriptUseCase(this.repository);

  @override
  Future<Either<Failure, List<BanScriptEntity>>> call(BanScriptParams params) async {
    return await repository.getBanScripts(exchange: params.exchange, banType: params.banType);
  }
}

class BanScriptParams {
  final String? exchange;
  final String? banType;

  BanScriptParams({this.exchange, this.banType});
}
