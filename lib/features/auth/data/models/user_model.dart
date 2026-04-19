import '../../domain/entities/user.dart';

class LoginUserModel extends User {
  const LoginUserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
    required super.accessToken,
    required super.refreshToken,
    required super.role,
  });

  /// Parses [equity.bazaarpro.app] `POST /auth/login` JSON body.
  factory LoginUserModel.fromLoginApi(Map<String, dynamic> json) {
    final tokenMap = json['token'] as Map<String, dynamic>?;
    final userMap = json['user'] as Map<String, dynamic>?;
    if (tokenMap == null || userMap == null) {
      throw const FormatException('Invalid login response');
    }

    final jwt = tokenMap['jwt_token'] as String? ?? '';
    final apiToken = tokenMap['api_token'] as String? ?? '';

    final rawRole = userMap['role'] as String? ?? '';
    final username = userMap['username'] as String? ?? '';
    final id = userMap['id'] as String? ?? '';

    final displayRole = mapApiRoleToUiRole(rawRole);
    final email = username.isNotEmpty ? username : '';

    final localPart =
        username.contains('@') ? username.split('@').first : username;

    return LoginUserModel(
      id: id,
      username: username,
      email: email,
      firstName: localPart.isNotEmpty ? localPart : displayRole,
      lastName: '',
      gender: '',
      image: '',
      accessToken: jwt,
      refreshToken: apiToken,
      role: displayRole,
    );
  }

  factory LoginUserModel.fromPersistedJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toPersistedJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
    };
  }

  factory LoginUserModel.fromEntity(User user) {
    return LoginUserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      gender: user.gender,
      image: user.image,
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
      role: user.role,
    );
  }
}

String mapApiRoleToUiRole(String apiRole) {
  switch (apiRole.toUpperCase()) {
    case 'SUPER_ADMIN':
      return 'Super Admin';
    case 'ADMIN':
      return 'Admin';
    case 'MASTER':
      return 'Master';
    case 'CLIENT':
      return 'Client';
    default:
      return apiRole;
  }
}
