import 'package:bazarpro/core/errors/failures.dart';
import 'package:bazarpro/features/users/domain/entities/user_sharing_details/user_sharing_details.dart';
import 'package:dartz/dartz.dart';


abstract class UserSharingDetailsRepository {
  Future<Either<Failure, UserSharingDetails>> getUserSharingDetails(
    String userId,
  );
}
