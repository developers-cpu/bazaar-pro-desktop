import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/pending_orders/pending_order.dart';
import '../../repositories/pending_orders/pending_orders_repository.dart';


/// Export to PDF Use Case
class ExportToPdf implements UseCase<String, ExportParams> {
  final PendingOrdersRepository repository;

  ExportToPdf(this.repository);

  @override
  Future<Either<Failure, String>> call(ExportParams params) async {
    return await repository.exportToPdf(params.orders);
  }
}

/// Export to Excel Use Case
class ExportToExcel implements UseCase<String, ExportParams> {
  final PendingOrdersRepository repository;

  ExportToExcel(this.repository);

  @override
  Future<Either<Failure, String>> call(ExportParams params) async {
    return await repository.exportToExcel(params.orders);
  }
}

/// Export Parameters
class ExportParams {
  final List<PendingOrder> orders;

  const ExportParams({required this.orders});
}