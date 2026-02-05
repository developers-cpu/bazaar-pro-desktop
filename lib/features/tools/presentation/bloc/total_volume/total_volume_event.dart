part of 'total_volume_bloc.dart';

abstract class TotalVolumeEvent extends Equatable {
  const TotalVolumeEvent();

  @override
  List<Object> get props => [];
}

class GetTotalVolumeExchangesEvent extends TotalVolumeEvent {}

class GetTotalVolumeEvent extends TotalVolumeEvent {
  final String exchange;

  const GetTotalVolumeEvent(this.exchange);

  @override
  List<Object> get props => [exchange];
}
