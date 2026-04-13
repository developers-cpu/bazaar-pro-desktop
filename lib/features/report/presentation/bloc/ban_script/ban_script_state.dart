import 'package:equatable/equatable.dart';
import '../../../domain/entities/ban_script_entity.dart';

abstract class BanScriptState extends Equatable {
  const BanScriptState();

  @override
  List<Object?> get props => [];
}

class BanScriptInitial extends BanScriptState {}

class BanScriptLoading extends BanScriptState {}

class BanScriptLoaded extends BanScriptState {
  final List<BanScriptEntity> data;
  final String? currentExchange;
  final String? currentBanType;

  const BanScriptLoaded({
    required this.data,
    this.currentExchange,
    this.currentBanType,
  });

  @override
  List<Object?> get props => [data, currentExchange, currentBanType];
}

class BanScriptError extends BanScriptState {
  final String message;

  const BanScriptError({required this.message});

  @override
  List<Object?> get props => [message];
}
