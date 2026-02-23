import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/my_profile_entity.dart';
abstract class MyProfileRepository {
  Future<Either<Failure, MyProfileEntity>> getMyProfile();
}
