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
class SaveSurveillanceDataEvent extends SurveillanceEvent {}
