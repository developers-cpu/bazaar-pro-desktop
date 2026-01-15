import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/pending_orders_repository.dart';


/// Get Clients Use Case
class GetClients implements UseCase<List<String>, NoParams> {
  final PendingOrdersRepository repository;

  GetClients(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getClients();
  }
}

/// Get Exchanges Use Case
class GetExchanges implements UseCase<List<String>, NoParams> {
  final PendingOrdersRepository repository;

  GetExchanges(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getExchanges();
  }
}

/// Get Symbols Use Case
class GetSymbols implements UseCase<List<String>, NoParams> {
  final PendingOrdersRepository repository;

  GetSymbols(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getSymbols();
  }
}

/// Get Order Types - Synchronous, no API call needed
class GetOrderTypes {
  final PendingOrdersRepository repository;

  GetOrderTypes(this.repository);

  List<String> call() {
    return repository.getOrderTypes();
  }
}