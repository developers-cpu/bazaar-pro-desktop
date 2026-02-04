import '../../../domain/entities/user.dart';
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.userName,
    required super.parentUser,
    required super.type,
    required super.name,
    required super.plPercent,
    required super.brkPercent,
    required super.leverage,
    required super.credit,
    required super.pl,
    required super.equity,
    required super.totalMargin,
    required super.usedMargin,
    required super.freeMargin,
    required super.createdDate,
    super.lastLoginDateTime,
    super.deviceType,
    super.ipAddress,
    required super.status,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      userName: json['user_name'] ?? json['userName'] ?? '',
      parentUser:
          json['parent_user'] ?? json['parentUser'] ?? json['par_user'] ?? '',
      type: json['type'] ?? json['user_type'] ?? '',
      name: json['name'] ?? '',
      plPercent: _parseDouble(
        json['pl_percent'] ?? json['plPercent'] ?? json['pl_pct'],
      ),
      brkPercent: _parseDouble(
        json['brk_percent'] ?? json['brkPercent'] ?? json['brk_pct'],
      ),
      leverage: json['leverage'] ?? json['lvrj'] ?? '1:1',
      credit: _parseDouble(json['credit']),
      pl: _parseDouble(json['pl'] ?? json['p_l']),
      equity: _parseDouble(json['equity']),
      totalMargin: _parseDouble(
        json['total_margin'] ?? json['totalMargin'] ?? json['tot_margin'],
      ),
      usedMargin: _parseDouble(json['used_margin'] ?? json['usedMargin']),
      freeMargin: _parseDouble(json['free_margin'] ?? json['freeMargin']),
      createdDate: _parseDateTime(json['created_date'] ?? json['createdDate']),
      lastLoginDateTime:
          json['last_login_dt'] != null || json['lastLoginDateTime'] != null
          ? _parseDateTime(json['last_login_dt'] ?? json['lastLoginDateTime'])
          : null,
      deviceType:
          json['device_type'] ?? json['deviceType'] ?? json['ty_off_device'],
      ipAddress: json['ip_address'] ?? json['ipAddress'],
      status: json['status'] ?? 'Active',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'parent_user': parentUser,
      'type': type,
      'name': name,
      'pl_percent': plPercent,
      'brk_percent': brkPercent,
      'leverage': leverage,
      'credit': credit,
      'pl': pl,
      'equity': equity,
      'total_margin': totalMargin,
      'used_margin': usedMargin,
      'free_margin': freeMargin,
      'created_date': createdDate.toIso8601String(),
      'last_login_dt': lastLoginDateTime?.toIso8601String(),
      'device_type': deviceType,
      'ip_address': ipAddress,
      'status': status,
    };
  }
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      userName: entity.userName,
      parentUser: entity.parentUser,
      type: entity.type,
      name: entity.name,
      plPercent: entity.plPercent,
      brkPercent: entity.brkPercent,
      leverage: entity.leverage,
      credit: entity.credit,
      pl: entity.pl,
      equity: entity.equity,
      totalMargin: entity.totalMargin,
      usedMargin: entity.usedMargin,
      freeMargin: entity.freeMargin,
      createdDate: entity.createdDate,
      lastLoginDateTime: entity.lastLoginDateTime,
      deviceType: entity.deviceType,
      ipAddress: entity.ipAddress,
      status: entity.status,
    );
  }
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
