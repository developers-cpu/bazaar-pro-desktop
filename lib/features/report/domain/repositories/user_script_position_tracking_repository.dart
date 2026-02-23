import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_script_position_tracking.dart';
abstract class UserScriptPositionTrackingRepository {
  Future<Either<Failure, List<UserScriptPositionTracking>>>
  getUserScriptPositionTracking({
    String? startDate,
    String? endDate,
    String? userId,
    String? exchange,
    String? symbol,
  });
}
