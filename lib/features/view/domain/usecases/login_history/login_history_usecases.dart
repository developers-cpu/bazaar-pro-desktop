import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/login_history/login_history.dart';
import '../../repositories/login_history/login_history_repository.dart';
class GetLoginHistory implements UseCase<List<LoginHistory>, String> {
  final LoginHistoryRepository repository;
  GetLoginHistory(this.repository);
  @override
  Future<Either<Failure, List<LoginHistory>>> call(String client) {
    return repository.getLoginHistory(client);
  }
}
class GetLoginHistoryClients implements UseCase<List<String>, NoParams> {
  final LoginHistoryRepository repository;
  GetLoginHistoryClients(this.repository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getClients();
  }
}
class ExportLoginHistoryToPdf implements UseCase<String, List<LoginHistory>> {
  final LoginHistoryRepository repository;
  ExportLoginHistoryToPdf(this.repository);
  @override
  Future<Either<Failure, String>> call(List<LoginHistory> history) {
    return repository.exportToPdf(history);
  }
}
class ExportLoginHistoryToExcel implements UseCase<String, List<LoginHistory>> {
  final LoginHistoryRepository repository;
  ExportLoginHistoryToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(List<LoginHistory> history) {
    return repository.exportToExcel(history);
  }
}
