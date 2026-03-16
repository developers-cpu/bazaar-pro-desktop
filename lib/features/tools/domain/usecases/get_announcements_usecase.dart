import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';
class GetAnnouncementsUseCase
    implements UseCase<List<AnnouncementEntity>, NoParams> {
  final AnnouncementRepository repository;
  GetAnnouncementsUseCase({required this.repository});
  @override
  Future<Either<Failure, List<AnnouncementEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getAnnouncements();
  }
}
