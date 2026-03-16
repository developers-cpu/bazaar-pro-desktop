import '../../domain/entities/total_volume_entity.dart';

class TotalVolumeModel extends TotalVolumeEntity {
  const TotalVolumeModel({
    required super.exchange,
    required super.totalVolume,
    required super.totalVolumeShort,
  });
  factory TotalVolumeModel.fromJson(Map<String, dynamic> json) {
    return TotalVolumeModel(
      exchange: json['exchange'] ?? '',
      totalVolume: json['totalVolume'] ?? '0',
      totalVolumeShort: json['totalVolumeShort'] ?? '0',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exchange': exchange,
      'totalVolume': totalVolume,
      'totalVolumeShort': totalVolumeShort,
    };
  }
}
