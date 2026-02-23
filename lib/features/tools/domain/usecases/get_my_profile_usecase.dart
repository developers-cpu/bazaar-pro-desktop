import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_profile_entity.dart';
import '../repositories/my_profile_repository.dart';
class GetMyProfileUseCase implements UseCase<MyProfileEntity, NoParams> {
  final MyProfileRepository repository;
  GetMyProfileUseCase(this.repository);
  @override
  Future<Either<Failure, MyProfileEntity>> call(NoParams params) {
    return repository.getMyProfile();
  }
}
