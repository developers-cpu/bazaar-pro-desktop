import 'package:equatable/equatable.dart';

abstract class ActivityDetailState extends Equatable {
  const ActivityDetailState();
  @override
  List<Object?> get props => [];
}

class ActivityDetailInitial extends ActivityDetailState {}

class ActivityDetailLoading extends ActivityDetailState {}

class ActivityDetailLoaded extends ActivityDetailState {
  final List<Map<String, dynamic>> details;
  final int recordCount;
  const ActivityDetailLoaded({
    required this.details,
    required this.recordCount,
  });
  @override
  List<Object?> get props => [details, recordCount];
}

class ActivityDetailError extends ActivityDetailState {
  final String message;
  const ActivityDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
