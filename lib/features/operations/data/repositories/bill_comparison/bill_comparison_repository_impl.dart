import '../../../domain/entities/bill_comparison/bill_comparison_entity.dart';
import '../../../domain/repositories/bill_comparison/bill_comparison_repository.dart';
import '../../datasources/bill_comparison/bill_comparison_remote_data_source.dart';

class BillComparisonRepositoryImpl implements BillComparisonRepository {
  final BillComparisonRemoteDataSource remoteDataSource;
  BillComparisonRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<BillComparisonEntity>> getBillComparisonData({
    required String startDate,
    required String endDate,
  }) async {
    return await remoteDataSource.getBillComparisonData(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
