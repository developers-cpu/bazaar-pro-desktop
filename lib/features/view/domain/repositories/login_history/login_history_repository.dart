import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/login_history/login_history.dart';
abstract class LoginHistoryRepository {
  Future<Either<Failure, List<LoginHistory>>> getLoginHistory(String client);
  Future<Either<Failure, List<String>>> getClients();
  Future<Either<Failure, String>> exportToPdf(List<LoginHistory> history);
  Future<Either<Failure, String>> exportToExcel(List<LoginHistory> history);
}
