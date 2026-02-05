import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/shortcut_entity.dart';
abstract class ShortcutsRepository {
  Future<Either<Failure, List<ShortcutEntity>>> getShortcuts();
}
