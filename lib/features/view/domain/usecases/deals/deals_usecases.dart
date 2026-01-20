import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/deals/deals.dart';
import '../../repositories/deals/deals_repository.dart';

/// Get all deals usecase
class GetDeals implements UseCase<List<Deal>, NoParams> {
  final DealsRepository repository;

  GetDeals(this.repository);

  @override
  Future<Either<Failure, List<Deal>>> call(NoParams params) {
    return repository.getDeals();
  }
}

/// Get deals with filters usecase
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

/// Filter parameters for deals
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

/// Get clients for filter
class GetDealsClients implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;

  GetDealsClients(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getClients();
  }
}

/// Get exchanges for filter
class GetDealsExchanges implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;

  GetDealsExchanges(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getExchanges();
  }
}

/// Get symbols for filter
class GetDealsSymbols implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;

  GetDealsSymbols(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSymbols();
  }
}

/// Get order types for filter
class GetDealsOrderTypes implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;

  GetDealsOrderTypes(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getOrderTypes();
  }
}

/// Get statuses for filter
class GetDealsStatuses implements UseCase<List<String>, NoParams> {
  final DealsRepository repository;

  GetDealsStatuses(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getStatuses();
  }
}

/// Export deals to PDF
class ExportDealsToPdf implements UseCase<String, List<Deal>> {
  final DealsRepository repository;

  ExportDealsToPdf(this.repository);

  @override
  Future<Either<Failure, String>> call(List<Deal> deals) {
    return repository.exportToPdf(deals);
  }
}

/// Export deals to Excel
class ExportDealsToExcel implements UseCase<String, List<Deal>> {
  final DealsRepository repository;

  ExportDealsToExcel(this.repository);

  @override
  Future<Either<Failure, String>> call(List<Deal> deals) {
    return repository.exportToExcel(deals);
  }
}