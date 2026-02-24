import 'package:equatable/equatable.dart';

abstract class OperationsMessageEvent extends Equatable {
  const OperationsMessageEvent();
  @override
  List<Object?> get props => [];
}

class ChangeMessageTabEvent extends OperationsMessageEvent {
  final int index;
  const ChangeMessageTabEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class ChangeRollTypeEvent extends OperationsMessageEvent {
  final String rollType;
  const ChangeRollTypeEvent(this.rollType);
  @override
  List<Object?> get props => [rollType];
}

class UpdateMessageEvent extends OperationsMessageEvent {
  final String content;
  const UpdateMessageEvent(this.content);
  @override
  List<Object?> get props => [content];
}
