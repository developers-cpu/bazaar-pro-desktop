part of 'total_volume_bloc.dart';
enum TotalVolumeStatus { initial, loading, success, error }
enum ExchangeStatus { initial, loading, success, error }
class TotalVolumeState extends Equatable {
  final TotalVolumeStatus status;
  final ExchangeStatus exchangeStatus;
  final List<String> exchanges;
  final TotalVolumeEntity? totalVolume;
  final String errorMessage;
  const TotalVolumeState({
    this.status = TotalVolumeStatus.initial,
    this.exchangeStatus = ExchangeStatus.initial,
    this.exchanges = const [],
    this.totalVolume,
    this.errorMessage = '',
  });
  TotalVolumeState copyWith({
    TotalVolumeStatus? status,
    ExchangeStatus? exchangeStatus,
    List<String>? exchanges,
    TotalVolumeEntity? totalVolume,
    String? errorMessage,
  }) {
    return TotalVolumeState(
      status: status ?? this.status,
      exchangeStatus: exchangeStatus ?? this.exchangeStatus,
      exchanges: exchanges ?? this.exchanges,
      totalVolume: totalVolume ?? this.totalVolume,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  @override
  List<Object?> get props => [
    status,
    exchangeStatus,
    exchanges,
    totalVolume,
    errorMessage,
  ];
}
