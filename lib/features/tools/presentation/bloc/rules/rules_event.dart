part of 'rules_bloc.dart';
abstract class RulesEvent extends Equatable {
  const RulesEvent();
  @override
  List<Object> get props => [];
}
class LoadRules extends RulesEvent {}
