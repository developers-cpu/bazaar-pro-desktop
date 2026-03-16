import '../../../domain/entities/group/group.dart';
class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.exchange,
    required super.groupName,
    required super.count,
    required super.updatedOn,
    required super.updatedBy,
    required super.isDefault,
  });
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? '',
      exchange: json['exchange'] ?? '',
      groupName: json['group_name'] ?? '',
      count: json['count'] ?? '0',
      updatedOn: json['updated_on'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchange': exchange,
      'group_name': groupName,
      'count': count,
      'updated_on': updatedOn,
      'updated_by': updatedBy,
      'is_default': isDefault,
    };
  }
}
