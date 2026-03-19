import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/script_master/script_master.dart';

abstract class ScriptMasterRepository {
  Future<Either<Failure, List<ScriptMaster>>> getScriptMasters();
  Future<Either<Failure, List<ScriptMaster>>> getScriptMastersWithFilters({
    String? exchange,
    String? symbol,
  });
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, String>> exportToPdf(List<ScriptMaster> scripts);
  Future<Either<Failure, String>> exportToExcel(List<ScriptMaster> scripts);
}