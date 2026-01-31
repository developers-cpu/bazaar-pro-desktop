import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/net_postion/net_position.dart';
import '../../../domain/repositories/net_postion/net_position_repository.dart';
import '../../datasources/net_position/net_position_remote_datasource.dart';
import '../../models/net_postion/net_position_model.dart';

class NetPositionRepositoryImpl implements NetPositionRepository {
  final NetPositionRemoteDataSource remoteDataSource;

  NetPositionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NetPosition>>> getNetPositions() async {
    try {
      final positions = await remoteDataSource.getNetPositions();
      return Right(positions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NetPosition>>> getNetPositionsWithFilters({
    String? userType,
    String? client,
    String? exchange,
    String? symbol,
  }) async {
    try {
      final positions = await remoteDataSource.getNetPositionsWithFilters(
        userType: userType,
        client: client,
        exchange: exchange,
        symbol: symbol,
      );
      return Right(positions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getClients() async {
    try {
      final clients = await remoteDataSource.getClients();
      return Right(clients);
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
  Future<Either<Failure, List<String>>> getUserTypes() async {
    try {
      final userTypes = await remoteDataSource.getUserTypes();
      return Right(userTypes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(List<NetPosition> positions) async {
    try {
      final models = positions.map((p) => NetPositionModel.fromEntity(p)).toList();
      final path = await remoteDataSource.exportToPdf(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(List<NetPosition> positions) async {
    try {
      final models = positions.map((p) => NetPositionModel.fromEntity(p)).toList();
      final path = await remoteDataSource.exportToExcel(models);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NetPosition>>> getPositionDetails({
    required String symbol,
    required String userName,
  }) async {
    try {
      final positions = await remoteDataSource.getPositionDetails(
        symbol: symbol,
        userName: userName,
      );
      return Right(positions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}