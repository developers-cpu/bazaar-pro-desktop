import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/net_postion/net_position.dart';

abstract class NetPositionRepository {
  Future<Either<Failure, List<NetPosition>>> getNetPositions();
  Future<Either<Failure, List<NetPosition>>> getNetPositionsWithFilters({
    String? userType,
    String? client,
    String? exchange,
    String? symbol,
  });
  Future<Either<Failure, List<String>>> getClients();
  Future<Either<Failure, List<String>>> getExchanges();
  Future<Either<Failure, List<String>>> getSymbols();
  Future<Either<Failure, List<String>>> getUserTypes();
  Future<Either<Failure, String>> exportToPdf(List<NetPosition> positions);
  Future<Either<Failure, String>> exportToExcel(List<NetPosition> positions);
  Future<Either<Failure, List<NetPosition>>> getPositionDetails({
    required String symbol,
    required String userName,
  });
}