import '../../../domain/entities/user_sharing_details/user_sharing_details.dart';
import '../../../domain/entities/user_sharing_info.dart';

class UserSharingDetailsModel extends UserSharingDetails {
  const UserSharingDetailsModel({
    required super.plSharing,
    required super.brokerageSharing,
  });

  factory UserSharingDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserSharingDetailsModel(
      plSharing:
          (json['plSharing'] as List<dynamic>?)
              ?.map((e) => UserSharingInfoModel.fromJson(e))
              .toList() ??
          [],
      brokerageSharing:
          (json['brokerageSharing'] as List<dynamic>?)
              ?.map((e) => UserSharingInfoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plSharing': plSharing
          .map((e) => (e as UserSharingInfoModel).toJson())
          .toList(),
      'brokerageSharing': brokerageSharing
          .map((e) => (e as UserSharingInfoModel).toJson())
          .toList(),
    };
  }
}

class UserSharingInfoModel extends UserSharingInfo {
  const UserSharingInfoModel({required super.person, required super.share});

  factory UserSharingInfoModel.fromJson(Map<String, dynamic> json) {
    return UserSharingInfoModel(
      person: json['person'] ?? '',
      share: json['share'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'person': person, 'share': share};
  }
}
