import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_remote_datasource.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;
  AnnouncementRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements() async {
    try {
      final announcements = await remoteDataSource.getAnnouncements();
      return Right(announcements);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
