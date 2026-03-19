import '../../domain/entities/rule_entity.dart';

class RuleModel extends RuleEntity {
  const RuleModel({
    required String id,
    required String rule,
    required String language,
  }) : super(id: id, rule: rule, language: language);
  factory RuleModel.fromJson(Map<String, dynamic> json) {
    return RuleModel(
      id: json['id'],
      rule: json['rule'],
      language: json['language'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'rule': rule, 'language': language};
  }
}