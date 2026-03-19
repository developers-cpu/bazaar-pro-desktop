import 'package:equatable/equatable.dart';
import '../../../domain/entities/exchange_wise_pl/exchange_wise_pl_report.dart';

abstract class ExchangeWisePLState extends Equatable {
  const ExchangeWisePLState();
  @override
  List<Object?> get props => [];
}

class ExchangeWisePLInitial extends ExchangeWisePLState {}

class ExchangeWisePLLoading extends ExchangeWisePLState {}

class ExchangeWisePLLoaded extends ExchangeWisePLState {
  final List<ExchangeWisePLReport> reports;
  const ExchangeWisePLLoaded({required this.reports});
  @override
  List<Object?> get props => [reports];
}

class ExchangeWisePLError extends ExchangeWisePLState {
  final String message;
  const ExchangeWisePLError({required this.message});
  @override
  List<Object?> get props => [message];
}