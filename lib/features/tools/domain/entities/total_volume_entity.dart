import 'package:equatable/equatable.dart';

class TotalVolumeEntity extends Equatable {
  final String exchange;
  final String totalVolume;
  final String totalVolumeShort;

  const TotalVolumeEntity({
    required this.exchange,
    required this.totalVolume,
    required this.totalVolumeShort,
  });

  @override
  List<Object?> get props => [exchange, totalVolume, totalVolumeShort];
}
