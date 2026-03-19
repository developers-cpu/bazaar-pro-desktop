import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/shortcut_entity.dart';
import '../repositories/shortcuts_repository.dart';

class GetShortcutsUseCase implements UseCase<List<ShortcutEntity>, NoParams> {
  final ShortcutsRepository repository;
  GetShortcutsUseCase(this.repository);
  @override
  Future<Either<Failure, List<ShortcutEntity>>> call(NoParams params) async {
    return await repository.getShortcuts();
  }
}