import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/shortcut_entity.dart';
import '../../domain/repositories/shortcuts_repository.dart';
import '../datasources/shortcuts_remote_datasource.dart';

class ShortcutsRepositoryImpl implements ShortcutsRepository {
  final ShortcutsRemoteDataSource remoteDataSource;
  ShortcutsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<ShortcutEntity>>> getShortcuts() async {
    try {
      final result = await remoteDataSource.getShortcuts();
      return Right(result);
    } catch (e) {
      return const Left(UnknownFailure('Server error occurred'));
    }
  }
}
