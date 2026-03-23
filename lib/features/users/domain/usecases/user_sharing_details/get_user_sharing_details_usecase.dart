import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_sharing_details/user_sharing_details.dart';
import 'package:bazarpro/features/users/domain/repositories/user_sharing_details/user_sharing_details_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserSharingDetails {
  final UserSharingDetailsRepository repository;
  GetUserSharingDetails(this.repository);
  Future<Either<Failure, UserSharingDetails>> call(String userId) {
    return repository.getUserSharingDetails(userId);
  }
}
