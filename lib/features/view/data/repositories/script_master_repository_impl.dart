import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/script_master.dart';
import '../../domain/repositories/script_master_repository.dart';
import '../datasources/script_master_remote_datasource.dart';
import '../models/script_master.dart';


/// Script Master repository implementation
class ScriptMasterRepositoryImpl implements ScriptMasterRepository {
  final ScriptMasterRemoteDataSource remoteDataSource;

  ScriptMasterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ScriptMaster>>> getScriptMasters() async {
    try {
      final scripts = await remoteDataSource.getScriptMasters();
      return Right(scripts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScriptMaster>>> getScriptMastersWithFilters({
    String? exchange,
    String? symbol,
  }) async {
    try {
      final scripts = await remoteDataSource.getScriptMastersWithFilters(
        exchange: exchange,
        symbol: symbol,
      );
      return Right(scripts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getExchanges() async {
    try {
      final exchanges = await remoteDataSource.getExchanges();
      return Right(exchanges);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSymbols() async {
    try {
      final symbols = await remoteDataSource.getSymbols();
      return Right(symbols);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(List<ScriptMaster> scripts) async {
    try {
      final models = scripts.map((s) => ScriptMasterModel.fromEntity(s)).toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(List<ScriptMaster> scripts) async {
    try {
      final models = scripts.map((s) => ScriptMasterModel.fromEntity(s)).toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}