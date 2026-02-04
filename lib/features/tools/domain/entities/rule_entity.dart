import 'package:equatable/equatable.dart';

class RuleEntity extends Equatable {
  final String id;
  final String rule;
  final String language; 

  const RuleEntity({
    required this.id,
    required this.rule,
    required this.language,
  });

  @override
  List<Object?> get props => [id, rule, language];
}
