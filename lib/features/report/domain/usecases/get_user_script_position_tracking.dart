import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_script_position_tracking.dart';
import '../repositories/user_script_position_tracking_repository.dart';

class GetUserScriptPositionTrackingUseCase {
  final UserScriptPositionTrackingRepository repository;

  GetUserScriptPositionTrackingUseCase({required this.repository});

  Future<Either<Failure, List<UserScriptPositionTracking>>> call({
    String? startDate,
    String? endDate,
    String? userId,
    String? exchange,
    String? symbol,
  }) {
    return repository.getUserScriptPositionTracking(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
      exchange: exchange,
      symbol: symbol,
    );
  }
}
