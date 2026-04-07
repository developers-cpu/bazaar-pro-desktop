import 'package:equatable/equatable.dart';

abstract class SurveillanceEvent extends Equatable {
  const SurveillanceEvent();
  @override
  List<Object> get props => [];
}

class LoadSurveillanceDataEvent extends SurveillanceEvent {}

class UpdateVpnRestrictionEvent extends SurveillanceEvent {
  final bool? masterRestriction;
  final bool? clientRestriction;
  const UpdateVpnRestrictionEvent({
    this.masterRestriction,
    this.clientRestriction,
  });
  @override
  List<Object> get props => [
    masterRestriction ?? false,
    clientRestriction ?? false,
  ];
}

class UpdateTradeSlLimitEvent extends SurveillanceEvent {
  final List<String> ids;
  final double tradeSlLimit;

  const UpdateTradeSlLimitEvent({
    required this.ids,
    required this.tradeSlLimit,
  });

  @override
  List<Object> get props => [ids, tradeSlLimit];
}

class UpdateSpotIndexSymbolsEvent extends SurveillanceEvent {
  final List<String> symbols;

  const UpdateSpotIndexSymbolsEvent({required this.symbols});

  @override
  List<Object> get props => [symbols];
}

class SaveSurveillanceDataEvent extends SurveillanceEvent {}
