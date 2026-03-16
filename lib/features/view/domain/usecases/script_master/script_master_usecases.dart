import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/script_master/script_master.dart';
import '../../repositories/script_master/script_master_repository.dart';
class GetScriptMasters implements UseCase<List<ScriptMaster>, NoParams> {
  final ScriptMasterRepository repository;
  GetScriptMasters(this.repository);
  @override
  Future<Either<Failure, List<ScriptMaster>>> call(NoParams params) {
    return repository.getScriptMasters();
  }
}
class GetScriptMastersWithFilters
    implements UseCase<List<ScriptMaster>, ScriptMasterFilterParams> {
  final ScriptMasterRepository repository;
  GetScriptMastersWithFilters(this.repository);
  @override
  Future<Either<Failure, List<ScriptMaster>>> call(
    ScriptMasterFilterParams params,
  ) {
    return repository.getScriptMastersWithFilters(
      exchange: params.exchange,
      symbol: params.symbol,
    );
  }
}
class ScriptMasterFilterParams {
  final String? exchange;
  final String? symbol;
  const ScriptMasterFilterParams({this.exchange, this.symbol});
}
class GetScriptMasterExchanges implements UseCase<List<String>, NoParams> {
  final ScriptMasterRepository repository;
  GetScriptMasterExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}
class GetScriptMasterSymbols implements UseCase<List<String>, NoParams> {
  final ScriptMasterRepository repository;
  GetScriptMasterSymbols(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}
class ExportScriptMastersToPdf implements UseCase<String, List<ScriptMaster>> {
  final ScriptMasterRepository repository;
  ExportScriptMastersToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<ScriptMaster> scripts) {
    return repository.exportToPdf(scripts);
  }
}
class ExportScriptMastersToExcel
    implements UseCase<String, List<ScriptMaster>> {
  final ScriptMasterRepository repository;
  ExportScriptMastersToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<ScriptMaster> scripts) {
    return repository.exportToExcel(scripts);
  }
}
