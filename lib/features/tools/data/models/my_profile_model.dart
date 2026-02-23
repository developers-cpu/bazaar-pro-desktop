import '../../domain/entities/my_profile_entity.dart';
class MyProfileModel extends MyProfileEntity {
  const MyProfileModel({
    required super.userName,
    required super.name,
    required super.credit,
    required super.remark,
    required super.leverage,
    required super.creditLimit,
    required super.mobile,
    required super.plSharing,
    required super.brkSharing,
    required super.exchanges,
  });
  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      userName: json['userName'] ?? '',
      name: json['name'] ?? '',
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      remark: json['remark'] ?? '',
      leverage: json['leverage'] ?? '1:1',
      creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0.0,
      mobile: json['mobile'] ?? '',
      plSharing: json['plSharing'] is Map ? json['plSharing'] : {},
      brkSharing: json['brkSharing'] is Map ? json['brkSharing'] : {},
      exchanges:
          (json['exchanges'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'name': name,
      'credit': credit,
      'remark': remark,
      'leverage': leverage,
      'creditLimit': creditLimit,
      'mobile': mobile,
      'plSharing': plSharing,
      'brkSharing': brkSharing,
      'exchanges': exchanges,
    };
  }
}
