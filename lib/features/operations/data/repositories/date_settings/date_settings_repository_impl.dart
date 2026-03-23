import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/date_settings/date_setting.dart';
import '../../../domain/repositories/date_settings/date_settings_repository.dart';
import '../../datasources/date_settings/date_settings_remote_data_source.dart';

class DateSettingsRepositoryImpl implements DateSettingsRepository {
  final DateSettingsRemoteDataSource remoteDataSource;
  DateSettingsRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<DateSetting>>> getDateSettings() async {
    try {
      final result = await remoteDataSource.getDateSettings();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateDateSettings({
    required List<String> ids,
    DateSetting? details,
  }) async {
    try {
      final result = await remoteDataSource.updateDateSettings(ids: ids);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
