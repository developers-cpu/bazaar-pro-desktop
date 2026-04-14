import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/exchange_settings/exchange_settings_repository.dart';

class UpdateMarketTimingsFromExcel implements UseCase<bool, UpdateMarketTimingsFromExcelParams> {
  final ExchangeSettingsRepository repository;

  UpdateMarketTimingsFromExcel(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateMarketTimingsFromExcelParams params) async {
    return await repository.updateMarketTimingsFromExcel(bytes: params.bytes);
  }
}

class UpdateMarketTimingsFromExcelParams {
  final List<int> bytes;

  UpdateMarketTimingsFromExcelParams({required this.bytes});
}
