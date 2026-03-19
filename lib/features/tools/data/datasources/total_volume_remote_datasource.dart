import '../models/total_volume_model.dart';

abstract class TotalVolumeRemoteDataSource {
  Future<TotalVolumeModel> getTotalVolume(String exchange);
}

class TotalVolumeRemoteDataSourceImpl implements TotalVolumeRemoteDataSource {
  @override
  Future<TotalVolumeModel> getTotalVolume(String exchange) async {
    await Future.delayed(const Duration(milliseconds: 500));
    String volume;
    String volumeShort;
    switch (exchange) {
      case 'NSE':
        volume = '2513645236';
        volumeShort = '251 Cr.';
        break;
      case 'MCX':
        volume = '1023456789';
        volumeShort = '102 Cr.';
        break;
      case 'CE/PE':
        volume = '50456123';
        volumeShort = '50 Cr.';
        break;
      default:
        volume = '892345612';
        volumeShort = '89 Cr.';
        break;
    }
    return TotalVolumeModel(
      exchange: exchange,
      totalVolume: volume,
      totalVolumeShort: volumeShort,
    );
  }
}