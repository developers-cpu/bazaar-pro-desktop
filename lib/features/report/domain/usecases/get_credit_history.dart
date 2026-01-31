import 'package:bazarpro/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/credit_history.dart';
import '../repositories/credit_history_repository.dart';

class GetCreditHistoryUseCase {
  final CreditHistoryRepository repository;

  GetCreditHistoryUseCase({required this.repository});

  Future<Either<Failure, List<CreditHistory>>> call({
    String? type,
    String? search,
  }) async {
    return await repository.getCreditHistory(type: type, search: search);
  }
}
