import 'package:bazarpro/features/tools/domain/entities/market_timing_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MarketTimingState extends Equatable {
  const MarketTimingState();

  @override
  List<Object> get props => [];
}

class MarketTimingInitial extends MarketTimingState {}

class MarketTimingLoading extends MarketTimingState {}

class MarketTimingLoaded extends MarketTimingState {
  final MarketTimingEntity data;

  const MarketTimingLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MarketTimingError extends MarketTimingState {
  final String message;

  const MarketTimingError(this.message);

  @override
  List<Object> get props => [message];
}
