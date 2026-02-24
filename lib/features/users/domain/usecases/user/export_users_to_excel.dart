import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/core/usecases/usecase.dart';
import 'package:bazarpro/features/users/domain/repositories/user/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'export_users_to_pdf.dart';

class ExportUsersToExcel implements UseCase<String, ExportUsersParams> {
  final UserRepository repository;
  ExportUsersToExcel(this.repository);
  @override
  Future<Either<Failure, String>> call(ExportUsersParams params) async {
    return await repository.exportToExcel(params.users);
  }
}
