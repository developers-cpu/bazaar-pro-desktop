import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/deals/deals.dart';
import '../../repositories/deals/deals_repository.dart';

class GetDeals implements UseCase<List<Deal>, NoParams> {
  final DealsRepository repository;
  GetDeals(this.repository);
  @override
  Future<Either<Failure, List<Deal>>> call(NoParams params) {
    return repository.getDeals();
  }
}

class GetDealsWithFilters implements UseCase<List<Deal>, DealsFilterParams> {
  final DealsRepository repository;
  GetDealsWithFilters(this.repository);
  @override
  Future<Either<Failure, List<Deal>>> call(DealsFilterParams params) {
    return repository.getDealsWithFilters(
      startDate: params.startDate,
      endDate: params.endDate,
      client: params.client,
      exchange: params.exchange,
      symbol: params.symbol,
      orderType: params.orderType,
      status: params.status,
    );
  }
}

class DealsFilterParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? client;
  final String? exchange;
  final String? symbol;
  final String? orderType;
  final String? status;
  const DealsFilterParams({
    this.startDate,
    this.endDate,
    this.client,
    this.exchange,
    this.symbol,
    this.orderType,
    this.status,
  });
}

class GetDealsClients implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;
  GetDealsClients(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getClients();
  }
}

class GetDealsExchanges implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;
  GetDealsExchanges(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}

class GetDealsSymbols implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;
  GetDealsSymbols(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}

class GetDealsOrderTypes implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;
  GetDealsOrderTypes(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getOrderTypes();
  }
}

class GetDealsStatuses implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;
  GetDealsStatuses(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getStatuses();
  }
}

class ExportDealsToPdf implements UseCase<String, List<Deal>> {
  final DealsRepository repository;
  ExportDealsToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<Deal> deals) {
    return repository.exportToPdf(deals);
  }
}

class ExportDealsToExcel implements UseCase<String, List<Deal>> {
  final DealsRepository repository;
  ExportDealsToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<Deal> deals) {
    return repository.exportToExcel(deals);
  }
}