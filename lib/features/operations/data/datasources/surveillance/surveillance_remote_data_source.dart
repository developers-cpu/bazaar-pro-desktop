import '../../models/surveillance/surveillance_data_model.dart';
abstract class SurveillanceRemoteDataSource {
  Future<SurveillanceDataModel> getSurveillanceData();
  Future<void> updateSurveillanceData(SurveillanceDataModel data);
}
