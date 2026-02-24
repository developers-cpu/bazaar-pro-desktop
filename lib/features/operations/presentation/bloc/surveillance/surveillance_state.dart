import 'package:equatable/equatable.dart';
import '../../../domain/entities/surveillance/surveillance_data.dart';

abstract class SurveillanceState extends Equatable {
  const SurveillanceState();
  @override
  List<Object?> get props => [];
}

class SurveillanceInitial extends SurveillanceState {}

class SurveillanceLoading extends SurveillanceState {}

class SurveillanceLoaded extends SurveillanceState {
  final SurveillanceData data;
  const SurveillanceLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class SurveillanceUpdateSuccess extends SurveillanceState {
  final SurveillanceData data;
  final String message;
  const SurveillanceUpdateSuccess({required this.data, required this.message});
  @override
  List<Object?> get props => [data, message];
}

class SurveillanceError extends SurveillanceState {
  final String message;
  final SurveillanceData? currentData;
  const SurveillanceError({required this.message, this.currentData});
  @override
  List<Object?> get props => [message, currentData];
}
