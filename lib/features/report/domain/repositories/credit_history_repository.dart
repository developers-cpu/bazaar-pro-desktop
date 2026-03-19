import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/credit_history.dart';

abstract class CreditHistoryRepository {
  Future<Either<Failure, List<CreditHistory>>> getCreditHistory({
    String? type,
    String? search,
  });
}