import '../../../domain/entities/user_group_settings/user_group_settings.dart';

class UserGroupSettingsModel extends UserGroupSettings {
  const UserGroupSettingsModel({
    required super.id,
    required super.groupName,
    required super.isAllowed,
    required super.maxQuantity,
  });
  factory UserGroupSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserGroupSettingsModel(
      id: json['id'],
      groupName: json['groupName'],
      isAllowed: json['isAllowed'],
      maxQuantity: (json['maxQuantity'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupName': groupName,
      'isAllowed': isAllowed,
      'maxQuantity': maxQuantity,
    };
  }
}
