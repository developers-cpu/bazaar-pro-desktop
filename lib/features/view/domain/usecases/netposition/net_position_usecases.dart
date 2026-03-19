import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/net_postion/net_position.dart';
import '../../repositories/net_postion/net_position_repository.dart';

class GetNetPositions implements UseCase<List<NetPosition>, NoParams> {
  final NetPositionRepository repository;
  GetNetPositions(this.repository);
  @override
  Future<Either<Failure, List<NetPosition>>> call(NoParams params) {
    return repository.getNetPositions();
  }
}

class GetNetPositionsWithFilters
    implements UseCase<List<NetPosition>, NetPositionFilterParams> {
  final NetPositionRepository repository;
  GetNetPositionsWithFilters(this.repository);
  @override
  Future<Either<Failure, List<NetPosition>>> call(
    NetPositionFilterParams params,
  ) {
    return repository.getNetPositionsWithFilters(
      userType: params.userType,
      client: params.client,
      exchange: params.exchange,
      symbol: params.symbol,
    );
  }
}

class NetPositionFilterParams {
  final String? userType;
  final String? client;
  final String? exchange;
  final String? symbol;
  const NetPositionFilterParams({
    this.userType,
    this.client,
    this.exchange,
    this.symbol,
  });
}

class GetNetPositionClients implements UseCase<List<String>, NoParams> {
  final NetPositionRepository repository;
  GetNetPositionClients(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getClients();
  }
}

class GetNetPositionExchanges implements UseCase<List<String>, NoParams> {
  final NetPositionRepository repository;
  GetNetPositionExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}

class GetNetPositionSymbols implements UseCase<List<String>, NoParams> {
  final NetPositionRepository repository;
  GetNetPositionSymbols(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}

class GetNetPositionUserTypes implements UseCase<List<String>, NoParams> {
  final NetPositionRepository repository;
  GetNetPositionUserTypes(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getUserTypes();
  }
}

class ExportNetPositionsToPdf implements UseCase<String, List<NetPosition>> {
  final NetPositionRepository repository;
  ExportNetPositionsToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<NetPosition> positions) {
    return repository.exportToPdf(positions);
  }
}

class ExportNetPositionsToExcel implements UseCase<String, List<NetPosition>> {
  final NetPositionRepository repository;
  ExportNetPositionsToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<NetPosition> positions) {
    return repository.exportToExcel(positions);
  }
}

class GetPositionDetails
    implements UseCase<List<NetPosition>, PositionDetailsParams> {
  final NetPositionRepository repository;
  GetPositionDetails(this.repository);
  @override
  Future<Either<Failure, List<NetPosition>>> call(
    PositionDetailsParams params,
  ) {
    return repository.getPositionDetails(
      symbol: params.symbol,
      userName: params.userName,
    );
  }
}

class PositionDetailsParams {
  final String symbol;
  final String userName;
  const PositionDetailsParams({required this.symbol, required this.userName});
}