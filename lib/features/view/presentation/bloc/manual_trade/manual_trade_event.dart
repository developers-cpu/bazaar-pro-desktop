import 'package:equatable/equatable.dart';

abstract class ManualTradeEvent extends Equatable {
  const ManualTradeEvent();
  @override
  List<Object?> get props => [];
}

class LoadManualTradeDataEvent extends ManualTradeEvent {
  const LoadManualTradeDataEvent();
}

class UpdateManualTradeFieldEvent extends ManualTradeEvent {
  final String field;
  final dynamic value;
  const UpdateManualTradeFieldEvent({required this.field, required this.value});
  @override
  List<Object?> get props => [field, value];
}

class SubmitManualTradeEvent extends ManualTradeEvent {
  final bool isBuy;
  const SubmitManualTradeEvent({required this.isBuy});
  @override
  List<Object?> get props => [isBuy];
}

class ConfirmManualTradeEvent extends ManualTradeEvent {
  const ConfirmManualTradeEvent();
}