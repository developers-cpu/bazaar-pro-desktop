part of 'rules_bloc.dart';

abstract class RulesState extends Equatable {
  const RulesState();
  @override
  List<Object> get props => [];
}

class RulesLoading extends RulesState {}

class RulesLoaded extends RulesState {
  final List<RuleEntity> rules;
  const RulesLoaded(this.rules);
  @override
  List<Object> get props => [rules];
}

class RulesError extends RulesState {
  final String message;
  const RulesError(this.message);
  @override
  List<Object> get props => [message];
}
