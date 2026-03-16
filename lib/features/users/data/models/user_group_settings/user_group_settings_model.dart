import '../../../domain/entities/user_group_settings/user_group_settings.dart';

class UserGroupSettingsModel extends UserGroupSettings {
  const UserGroupSettingsModel({
    required super.id,
    required super.groupName,
    required super.isAllowed,
    required super.maxQuantity,
    super.lastUpdated,
  });
  factory UserGroupSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserGroupSettingsModel(
      id: json['id'],
      groupName: json['groupName'],
      isAllowed: json['isAllowed'],
      maxQuantity: (json['maxQuantity'] as num).toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupName': groupName,
      'isAllowed': isAllowed,
      'maxQuantity': maxQuantity,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}
